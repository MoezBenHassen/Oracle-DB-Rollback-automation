DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-60131_Update_Inventory_Manager_Feed';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;
EXECUTE IMMEDIATE 'ALTER TABLE ColFirmPosition ADD isSettled NUMBER(1) DEFAULT 1 ';
EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_INVMANAGER ADD isSettled VARCHAR2(50) ';


INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
