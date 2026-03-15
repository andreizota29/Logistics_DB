-- 100M+ rows generation with PL/SQL loop 
-- create coordinate data (gps pings) that mimick real tracking data

DECLARE
    v_batch_size CONSTANT NUMBER := 50000;
    v_total_rows CONSTANT NUMBER := 100000000; 
BEGIN
    FOR i IN 1 .. (v_total_rows / v_batch_size) LOOP
        INSERT /*+ APPEND */ INTO Shipment_Tracking (track_id, ship_id, loc_timestamp, lat_coord, long_coord)
        SELECT 
            (i-1)*v_batch_size + level,
            trunc(dbms_random.value(1, 1000000)),        -- Linking to 1M shipments
            sysdate - dbms_random.value(0, 365),         -- Random date within last year
            44.4268 + dbms_random.value(-1, 1),          -- Realistic Latitude (around Romania/EU)
            26.1025 + dbms_random.value(-1, 1)           -- Realistic Longitude
        FROM dual CONNECT BY level <= v_batch_size;
        
        COMMIT; 
    END LOOP;
END;
/