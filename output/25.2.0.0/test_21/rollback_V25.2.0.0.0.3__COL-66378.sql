-- 🔁 Rollback of V25.2.0.0.0.3__COL-66378.sql
ALTER TABLE colrptinassetsettlement DROP COLUMN excludeflushed;
-- ⚠️ MANUAL CHECK REQUIRED: the following UPDATE needs to be manually rolledback
-- ORIGINAL: EXECUTE IMMEDIATE 'UPDATE ColRptInAssetSettlement SET excludeFlushed=''No''';
DELETE FROM lrsschemaproperties WHERE modulename = 'v_module' AND propertyname = 'v_property' ;
