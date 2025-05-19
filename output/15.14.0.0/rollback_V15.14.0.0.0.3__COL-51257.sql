-- 🔁 Rollback of V15.14.0.0.0.3__COL-51257.sql
ALTER TABLE feed_staging_good_agreement DROP COLUMN assettypenames;
ALTER TABLE feed_staging_good_agreement DROP COLUMN applicableparties;
ALTER TABLE feed_staging_good_agreement DROP COLUMN applicabletypes;
ALTER TABLE feed_staging_good_agreement DROP COLUMN agrvstempeligrules;
ALTER TABLE feed_staging_good_agreement DROP COLUMN settlementdates;
ALTER TABLE feed_staging_good_agreement DROP COLUMN deliverypriorities;
ALTER TABLE feed_staging_good_agreement DROP COLUMN recallpriorities;
ALTER TABLE feed_staging_good_agreement DROP COLUMN assetnotes1;
ALTER TABLE feed_staging_good_agreement DROP COLUMN assetnotes2;
ALTER TABLE feed_staging_good_agreement DROP COLUMN assetnotes3;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-51257_S3_Feed_Agreement_Collateral_Assets' ;
