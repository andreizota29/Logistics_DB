## 1. Physical Architecture (Storage Layer)

To optimize I/O performance and prevent hardware bottlenecks, the database is distributed across three distinct physical disks. 
This separation ensures that "Heavy Writes"  do not interfere with "Heavy Reads" (Indexes).

| Tablespace | Physical Path | Allocation | Purpose |
| --- | --- | --- | --- |
| **`LOG_REF_TS`** | `/ora/disk1/` | 500 MB | Reference data, Metadata, and Materialized Views. |
| **`LOG_DATA_TS`** | `/ora/disk2/` | 20 GB | Large transactional data (100M+ rows) with Auto-extend. |
| **`LOG_IDX_TS`** | `/ora/disk3/` | 10 GB | High-speed Indexing for search optimization. |

### Storage Tuning (PCTFREE)

We implemented specific block-level tuning to manage how data is physically packed:

* **`PCTFREE 20` (Table `SHIPMENTS`):** Reserved 20% of each block for future status updates (e.g., "In Transit" to "Delivered") to prevent Row Chaining.
* **`PCTFREE 0` (Table `SYSTEM_AUDIT`):** Maximized density for read-only logs that are never updated, saving significant disk space.

## 2. Logical Schema Design

The schema consists of 10 primary tables managed by the `LOG_ARCHITECT` user.

* **Reference Tier:** `Countries`, `Cities`, `Vehicle_Types`.
* **Operational Tier:** `Hubs`, `Fleet`, `Drivers`, `Customers`, `Shipments`.
* **Big Data Tier:** `Shipment_Tracking` (Stores 100,000,000 rows generated via PL/SQL bulk insertion).
* **Audit Tier:** `System_Audit` (Logs system-wide events).

## 3. Performance & Optimization Segments

To meet the assessment requirements for "complex segments beyond simple tables," the following were implemented:

### A. Physical Materialized Views (Snapshot Tier)

Unlike standard views, these are physical segments stored on **Disk 1** to provide instant reporting.

1. **`MV_SHIPMENT_SUMMARY`**: Provides pre-calculated event counts per shipment.
2. **`MV_ROMANIA_SHIPMENTS`**: A geographic subset of data filtered for Romanian coordinates ($43^{\circ}–49^{\circ} N, 20^{\circ}–30^{\circ} E$).
* *Constraint:* Limited to 50,000 rows to ensure fit within the 500MB `LOG_REF_TS` allocation.

### B. Logical Views (Virtual Tier)

1. **`V_ROMANIA_SHIPMENTS`**: A virtual window providing real-time filtering without consuming additional disk space.
2. **`V_SHIPMENT_SUMMARY_LOGICAL`**: A logical equivalent to the MV used for performance benchmarking.

### C. Advanced Indexing

* **`idx_track_id`**: A Unique Index pinned to **Disk 3**. Created using `NOLOGGING` and `PARALLEL 2` to accelerate the initial build on the 100M-row dataset.

## 4. Automation & Maintenance

* **Sequence (`track_id_seq`)**: Automates ID generation starting at 100M to prevent collisions with legacy data.
* **Trigger (`TRG_AUDIT_TRACKING`)**: An event-driven component that automatically populates the `System_Audit` table whenever new tracking data is ingested.
* **Statistics**: Schema-wide statistics were gathered using `DBMS_STATS.GATHER_SCHEMA_STATS` to ensure the Oracle Optimizer makes the fastest execution choices.


## 5. Benchmarking & Stress Test Results

The architecture was validated through "Stress Tests" comparing the Base Table (Disk 2) against the Summary Tier (Disk 1).

| Test Case | Method | Timing | Observation |
| --- | --- | --- | --- |
| **Real-time Count** | Full Scan (100M rows) | ~15.22s | High I/O load on Disk 2. |
| **Snapshot Query** | Materialized View | **0.01s** | **1500x faster** than real-time calculation. |
| **Index Lookup** | Unique Index (Disk 3) | **0.00s** | Sub-second retrieval of a single record among 100M. |
