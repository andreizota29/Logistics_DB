-- trigger for system audit
CREATE OR REPLACE TRIGGER LOG_ARCHITECT.TRG_AUDIT_TRACKING
AFTER INSERT ON LOG_ARCHITECT.Shipment_Tracking
FOR EACH ROW
BEGIN
    INSERT INTO LOG_ARCHITECT.System_Audit (log_id, action_desc)
    VALUES (LOG_ARCHITECT.track_id_seq.NEXTVAL, 'New tracking point added for Ship ID: ' || :NEW.ship_id);
END;
/



