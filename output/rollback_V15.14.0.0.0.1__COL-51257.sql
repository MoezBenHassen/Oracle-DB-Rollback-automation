-- 🔁 Rollback of V15.14.0.0.0.1__COL-51257.sql
DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-51257_S3_Feed_Agreement_Collateral_Tab';
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
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN referenceRatingAgencies';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN debtClassification';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN selectionOfAgencyDirection';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN selectionOfAgencyUse';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN applicationOfRating';

  -- Revert: DELETE inserted row
  DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;
COMMIT;
