-- 🔁 Rollback of V25.2.0.0.0.3__COL-66378.sql
ALTER TABLE ColRptInAssetSettlement DROP COLUMN excludeFlushed;
DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;
