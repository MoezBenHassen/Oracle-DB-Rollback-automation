-- 🔁 Rollback of V15.14.0.0.0.4__COL-51258.sql
ALTER TABLE feed_staging_good_agreement DROP COLUMN selectedproduct;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-51258_S2_Products_tab' ;
