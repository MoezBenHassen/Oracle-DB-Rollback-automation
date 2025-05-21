-- 🔁 Rollback of V15.14.0.0.0.4__COL-51258.sql
ALTER TABLE feed_staging_good_agreement DROP COLUMN selectedproduct;
DELETE FROM lrsschemaproperties WHERE modulename = 'v_module' AND propertyname = 'v_property' ;
