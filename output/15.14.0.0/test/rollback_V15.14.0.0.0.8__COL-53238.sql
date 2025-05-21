-- 🔁 Rollback of V15.14.0.0.0.8__COL-53238.sql
-- ⚠️ MANUAL CHECK REQUIRED: CASE NOT HANDLED
-- ORIGINAL: EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN SPLITSETTLEMENTPERIOD';
ALTER TABLE feed_staging_good_agreement DROP COLUMN splitsettlementperiod;
ALTER TABLE feed_staging_good_agreement DROP COLUMN settlementdateabbriviateddeliveries;
DELETE FROM lrsschemaproperties WHERE modulename = 'v_module' AND propertyname = 'v_property' ;
