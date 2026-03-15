--stress test


--no index
SELECT /*+ FULL(st) */ count(*) 
FROM LOG_ARCHITECT.Shipment_Tracking st 
WHERE track_id = 50000000;


--index
SELECT /*+ INDEX(st idx_track_id) */ count(*) 
FROM LOG_ARCHITECT.Shipment_Tracking st 
WHERE track_id = 50000000;

--real time calculation
SET TIMING ON
SELECT COUNT(*) AS total_real_time_events
FROM LOG_ARCHITECT.Shipment_Tracking
WHERE ship_id = 250134;


--query on materialized view
SET TIMING ON
SELECT tracking_events AS snapshot_events
FROM LOG_ARCHITECT.MV_SHIPMENT_SUMMARY
WHERE ship_id = 250134;