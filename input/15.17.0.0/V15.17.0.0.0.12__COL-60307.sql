DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-60307_Add_LB_Bookings_Fields_To_AHV';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'ALTER TABLE COLRPTINASSETHOLDINGS ADD (linkedTicketIdLB NUMBER(19) DEFAULT 0, linkedTicketComment VARCHAR(20), bookingSource NUMBER(19) DEFAULT 0)';
EXECUTE IMMEDIATE 'ALTER TABLE COLRPTOUTASSETHOLDINGS ADD (linkedTicketIdLB NUMBER(19) DEFAULT 0, linkedTicketComment VARCHAR(20), bookingSource NUMBER(19) DEFAULT 0)';
EXECUTE IMMEDIATE 'ALTER TABLE ColRptInAssetSettlement ADD (linkedTicketComment VARCHAR(20))';
EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutAssetSettlement ADD (linkedTicketComment VARCHAR(20))';


INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
