DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-58223_S2.3_Agreement_Feed';
BEGIN

SELECT count(1)
INTO results
FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
  THEN
    RETURN;
END IF;

EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT ADD Bffr CLOB';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT ADD IMBffr CLOB';


INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;