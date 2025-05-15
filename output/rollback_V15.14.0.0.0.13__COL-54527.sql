-- 🔁 Rollback of V15.14.0.0.0.13__COL-54527.sql
DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-54527_split_settlement_date_fix';
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

  -- Original DROP COLUMN detected, manual revert required: EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN SETTLEMENTDATEABBRIVIATEDDELIVERIES';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN SETTLEMENTDATEABBRIVIATEDDELIVERIES';

  -- Revert: DELETE inserted row
  DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;
COMMIT;
