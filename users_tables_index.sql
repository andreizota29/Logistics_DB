-- dedicated architect user
CREATE USER LOG_ARCHITECT IDENTIFIED BY "architect";
GRANT CONNECT, RESOURCE TO LOG_ARCHITECT;
ALTER USER LOG_ARCHITECT QUOTA UNLIMITED ON LOG_REF_TS;
ALTER USER LOG_ARCHITECT QUOTA UNLIMITED ON LOG_DATA_TS;
ALTER USER LOG_ARCHITECT QUOTA UNLIMITED ON LOG_IDX_TS;

-- Connect as the new user
CONNECT LOG_ARCHITECT/Oracle2026!;

-- reference tables on '/ora/disk1/log_ref01.dbf' LOG_REF_TS
CREATE TABLE Countries (id NUMBER PRIMARY KEY, name VARCHAR2(50)) TABLESPACE LOG_REF_TS;
CREATE TABLE Cities (id NUMBER PRIMARY KEY, name VARCHAR2(50), country_id NUMBER) TABLESPACE LOG_REF_TS;
CREATE TABLE Vehicle_Types (id NUMBER PRIMARY KEY, type_name VARCHAR2(50)) TABLESPACE LOG_REF_TS;

-- operational tables on '/ora/disk1/log_data01.dbf' LOG_DATA_TS
CREATE TABLE Hubs (id NUMBER PRIMARY KEY, city_id NUMBER, hub_name VARCHAR2(100)) TABLESPACE LOG_DATA_TS;
CREATE TABLE Fleet (id NUMBER PRIMARY KEY, vehicle_type_id NUMBER, plate_no VARCHAR2(20)) TABLESPACE LOG_DATA_TS;
CREATE TABLE Drivers (id NUMBER PRIMARY KEY, full_name VARCHAR2(100), license_no VARCHAR2(20)) TABLESPACE LOG_DATA_TS;
CREATE TABLE Customers (id NUMBER PRIMARY KEY, cust_name VARCHAR2(100)) TABLESPACE LOG_DATA_TS;

--Big Data Tier (PCTFREE tuning)
-- PCTFREE 20: Leaves room for "Status" updates (In Transit -> Delivered)
CREATE TABLE Shipments (
    ship_id NUMBER PRIMARY KEY, 
    cust_id NUMBER, 
    status VARCHAR2(20)
) TABLESPACE LOG_DATA_TS PCTFREE 20;

-- The 100M Row Table: Segment Type = TABLE
CREATE TABLE Shipment_Tracking (
    track_id NUMBER NOT NULL,
    ship_id NUMBER NOT NULL,
    loc_timestamp TIMESTAMP,
    lat_coord NUMBER(9,6),
    long_coord NUMBER(9,6)
) TABLESPACE LOG_DATA_TS STORAGE (INITIAL 10M);

-- Log Table: PCTFREE 0 (Read-only history, maximum density)
CREATE TABLE System_Audit (
    log_id NUMBER PRIMARY KEY,
    action_desc VARCHAR2(200)
) TABLESPACE LOG_DATA_TS PCTFREE 0;

-- index segment placed on Disk 3 to separate I/O
CREATE INDEX idx_track_ship ON Shipment_Tracking(ship_id) TABLESPACE LOG_IDX_TS;


