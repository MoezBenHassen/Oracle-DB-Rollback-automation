-- 🔁 Rollback of V25.2.0.0.0.0__COL-66233.sql
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

  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_STATICDATA DROP COLUMN category';


  -- Revert: DELETE inserted row
  DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;
COMMIT;
