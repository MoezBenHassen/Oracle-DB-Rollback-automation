-- 🔁 Rollback of V15.14.0.0.0.12__COL-52633.sql
ALTER TABLE colworkflowinterfaceref DROP COLUMN cancelcomment;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52633_Add_comment_field' ;
