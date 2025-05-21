-- 🔁 Rollback of V15.14.0.0.0.1__COL-51257.sql
ALTER TABLE feed_staging_good_agreement DROP COLUMN referenceratingagencies;
ALTER TABLE feed_staging_good_agreement DROP COLUMN debtclassification;
ALTER TABLE feed_staging_good_agreement DROP COLUMN selectionofagencydirection;
ALTER TABLE feed_staging_good_agreement DROP COLUMN selectionofagencyuse;
ALTER TABLE feed_staging_good_agreement DROP COLUMN applicationofrating;
DELETE FROM lrsschemaproperties WHERE modulename = 'v_module' AND propertyname = 'v_property' ;
