-- 🔁 Rollback of V25.2.0.0.0.6__COL-58089.sql
ALTER TABLE feed_staging_good_security DROP COLUMN corporateaction;
ALTER TABLE feed_staging_good_security DROP COLUMN corporateactionsexcel;
ALTER TABLE feed_staging_good_security DROP COLUMN corporateactionsdateexcel;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-58089_Corporate_Actions_Enhancement' ;
