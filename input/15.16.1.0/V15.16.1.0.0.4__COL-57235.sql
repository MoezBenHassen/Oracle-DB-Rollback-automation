DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-57235_Feed_Extract_impacts';
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

EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT ADD THIRDPARTYAPPROVALTYPE VARCHAR2(250)';
EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT ADD THIRDPARTYAPPROVAL VARCHAR2(250)';



INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;