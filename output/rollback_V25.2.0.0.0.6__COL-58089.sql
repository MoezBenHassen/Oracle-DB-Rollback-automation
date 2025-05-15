-- 🔁 Rollback of V25.2.0.0.0.6__COL-58089.sql
DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-58089_Corporate_Actions_Enhancement';
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


  -- Original DROP COLUMN detected, manual revert required: EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_SECURITY DROP COLUMN CORPORATEACTION';
  -- Original DROP COLUMN detected, manual revert required: EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_SECURITY DROP COLUMN CORPORATEACTIONDATE';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_SECURITY DROP COLUMN CORPORATEACTION';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_SECURITY DROP COLUMN CORPORATEACTIONSEXCEL';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_SECURITY DROP COLUMN CORPORATEACTIONSDATEEXCEL';

  -- Revert: DELETE inserted row
  DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;
COMMIT;
END;
/
