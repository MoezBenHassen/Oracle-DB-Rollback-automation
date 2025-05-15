-- 🔁 Rollback of V15.14.0.0.0.2__COL-51246.sql
DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-51246_S4_Feed_Agreement_Settlement_Tab';
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
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN CallReturn';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN DeliveryRecall';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN InterestPay';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN InterestReceive';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN IMCallReturn';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN IMDeliveryRecall';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN IMInterestPay';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN IMInterestReceive';

  -- Revert: DELETE inserted row
  DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;
COMMIT;
