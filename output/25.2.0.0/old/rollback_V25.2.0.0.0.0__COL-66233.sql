-- 🔁 Rollback of V25.2.0.0.0.0__COL-66233.sql
ALTER TABLE feed_staging_good_staticdata DROP COLUMN category;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-66233_Feed_Static_Data' ;
