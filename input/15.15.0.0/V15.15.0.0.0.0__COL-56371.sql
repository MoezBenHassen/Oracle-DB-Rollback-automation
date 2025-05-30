DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
v_property VARCHAR2(100) := 'COL-56371_Add_fields_in_FEED_STAGING_GOOD_CPAMT';
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

EXECUTE IMMEDIATE 'alter table FEED_STAGING_GOOD_CPAMT add userAgreedAmount float(126)';
EXECUTE IMMEDIATE 'alter table FEED_STAGING_GOOD_CPAMT add overwrite VARCHAR2(50)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
