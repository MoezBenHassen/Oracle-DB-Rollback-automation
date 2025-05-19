DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
v_property VARCHAR2(100) := 'COL-66233_Feed_Static_Data';
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

EXECUTE IMMEDIATE 'alter table FEED_STAGING_GOOD_STATICDATA add category VARCHAR2(50)';

EXECUTE IMMEDIATE 'UPDATE ColRptInAssetSettlement SET excludeFlushed=''No''';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;