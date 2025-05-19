-- 🔁 Rollback of V15.14.0.0.0.15__COL-55204.sql
ALTER TABLE colworkflowinterfaceref DROP COLUMN collineissuesubs;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-55204_Add_collineIssueSubs_field' ;
