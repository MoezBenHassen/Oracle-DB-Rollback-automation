-- 🔁 Rollback of V25.2.0.0.0.0__COL-66233.sql
ALTER TABLE feed_staging_good_staticdata DROP COLUMN category;
-- ⚠️ MANUAL CHECK REQUIRED: the following UPDATE needs to be manually rolledback
-- ORIGINAL: EXECUTE IMMEDIATE 'UPDATE ColRptInAssetSettlement SET excludeFlushed=''No''';
DELETE FROM lrsschemaproperties WHERE modulename = 'v_module' AND propertyname = 'v_property' ;
