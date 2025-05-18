-- 🔁 Rollback of V25.2.0.0.0.5__COL-67825.sql
DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;
