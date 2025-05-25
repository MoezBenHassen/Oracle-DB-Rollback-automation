DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-50311_Feed_Security';
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

EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_SECURITY ADD corporateAction VARCHAR2(255)';
EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_SECURITY ADD corporateActionDate  TIMESTAMP (9)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
