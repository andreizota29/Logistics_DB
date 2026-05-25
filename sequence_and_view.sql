-- sequence
CREATE SEQUENCE LOG_ARCHITECT.track_id_seq START WITH 100000001 INCREMENT BY 1;

--mv
CREATE MATERIALIZED VIEW LOG_ARCHITECT.MV_SHIPMENT_SUMMARY
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT 
    cust_id, 
    status, 
    COUNT(ship_id) AS total_shipments
FROM 
    LOG_ARCHITECT.Shipments
GROUP BY 
    cust_id, 
    status;

CREATE MATERIALIZED VIEW LOG_ARCHITECT.MV_ROMANIA_SHIPMENTS
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
AS
SELECT 
    s.ship_id, 
    s.cust_id, 
    s.status
FROM 
    LOG_ARCHITECT.Shipments s
JOIN 
    LOG_ARCHITECT.Hubs h ON s.ship_id = h.hub_id -- (sau o coloană similară de legătură geografică)
JOIN 
    LOG_ARCHITECT.Countries c ON h.country_id = c.country_id
WHERE 
    c.country_name = 'Romania';


-- refresh

CONNECT LOG_ARCHITECT/architect;
EXEC DBMS_MVIEW.REFRESH('LOG_ARCHITECT.MV_SHIPMENT_SUMMARY');
EXEC DBMS_MVIEW.REFRESH('LOG_ARCHITECT.MV_ROMANIA_SHIPMENTS');
