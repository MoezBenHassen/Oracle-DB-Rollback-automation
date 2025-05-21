-- 🔁 Rollback of V15.14.0.0.0.12__COL-52633.sql
ALTER TABLE colworkflowinterfaceref DROP COLUMN cancelcomment;
DELETE FROM lrsschemaproperties WHERE modulename = 'v_module' AND propertyname = 'v_property' ;
