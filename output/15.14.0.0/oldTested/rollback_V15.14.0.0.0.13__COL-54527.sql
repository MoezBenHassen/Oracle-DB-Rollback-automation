-- 🔁 Rollback of V15.14.0.0.0.13__COL-54527.sql
-- ⚠️ MANUAL CHECK REQUIRED: CASE NOT HANDLED
-- ORIGINAL: EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN SETTLEMENTDATEABBRIVIATEDDELIVERIES';
ALTER TABLE feed_staging_good_agreement DROP COLUMN settlementdateabbriviateddeliveries;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-54527_split_settlement_date_fix' ;
