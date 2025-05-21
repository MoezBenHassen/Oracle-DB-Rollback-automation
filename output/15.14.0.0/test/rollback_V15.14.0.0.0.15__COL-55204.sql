-- 🔁 Rollback of V15.14.0.0.0.15__COL-55204.sql
ALTER TABLE colworkflowinterfaceref DROP COLUMN collineissuesubs;
DELETE FROM lrsschemaproperties WHERE modulename = 'v_module' AND propertyname = 'v_property' ;
