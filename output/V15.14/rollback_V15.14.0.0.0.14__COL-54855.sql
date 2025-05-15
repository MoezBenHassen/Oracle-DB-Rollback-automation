-- 🔁 Rollback of V15.14.0.0.0.14__COL-54855.sql
DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-54855_fix size INTERESTPAY in FEED_STAGING_GOOD_AGREEMENT';
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

  -- MODIFY detected, manual revert required
  -- EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT MODIFY INTERESTPAY VARCHAR2(50)';

  -- Revert: DELETE inserted row
  DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;
COMMIT;
