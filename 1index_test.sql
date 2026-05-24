SET LINESIZE 200;
SET PAGESIZE 50;


-- idx_track_id TEST
-- ignore index
SET TIMING ON
SELECT /*+ FULL(st) GATHER_PLAN_STATISTICS */ * FROM LOG_ARCHITECT.Shipment_Tracking st 
WHERE track_id = 50000000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALLSTATS LAST'));
--with index
SELECT /*+ INDEX(st idx_track_id) GATHER_PLAN_STATISTICS */ * FROM LOG_ARCHITECT.Shipment_Tracking st 
WHERE track_id = 50000000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALLSTATS LAST'));


-- idx_cust_status
-- ignore index
ALTER INDEX LOG_ARCHITECT.idx_cust_status INVISIBLE;
SET TIMING ON
SELECT /*+ GATHER_PLAN_STATISTICS */ s.ship_id, c.cust_name, s.status
FROM LOG_ARCHITECT.Customers c
JOIN LOG_ARCHITECT.Shipments s ON c.id = s.cust_id
WHERE s.cust_id = 1 AND s.status = 'In Transit';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALLSTATS LAST'));
-- with index
ALTER INDEX LOG_ARCHITECT.idx_cust_status VISIBLE;
SELECT /*+ GATHER_PLAN_STATISTICS */ s.ship_id, c.cust_name, s.status
FROM LOG_ARCHITECT.Customers c
JOIN LOG_ARCHITECT.Shipments s ON c.id = s.cust_id
WHERE s.cust_id = 1 AND s.status = 'In Transit';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALLSTATS LAST'));

-- idx_func_time
-- ignore index
SELECT /*+ NO_INDEX(st idx_func_time) GATHER_PLAN_STATISTICS */ COUNT(*) 
FROM LOG_ARCHITECT.Shipment_Tracking st 
WHERE TRUNC(loc_timestamp) = TRUNC(SYSDATE - 10);
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALLSTATS LAST'));
-- with index
SELECT /*+ INDEX(st idx_func_time) GATHER_PLAN_STATISTICS */ COUNT(*) 
FROM LOG_ARCHITECT.Shipment_Tracking st 
WHERE TRUNC(loc_timestamp) = TRUNC(SYSDATE - 10);
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALLSTATS LAST'));



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
