-- audit query

SELECT 
    owner,
    segment_type,
    tablespace_name,
    COUNT(*) as object_count,
    ROUND(SUM(bytes)/1024/1024, 2) as total_mb
FROM 
    dba_segments 
WHERE 
    owner = 'LOG_ARCHITECT'
GROUP BY 
    owner, segment_type, tablespace_name
ORDER BY 
    tablespace_name;