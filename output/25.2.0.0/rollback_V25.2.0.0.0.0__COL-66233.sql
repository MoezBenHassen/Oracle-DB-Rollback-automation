-- 🔁 Rollback of V25.2.0.0.0.0__COL-66233.sql
DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;
