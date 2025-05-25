-- 🔁 Rollback for PL/SQL V15.15.2.0.0.1__COL-52255.sql
ALTER TABLE ColAgreementPartyAssets DROP COLUMN prevInternalPolicyPermitsReuse;
ALTER TABLE ColAgreementPartyAssets DROP COLUMN forceChanged;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52255_Add_fields_in_ColAgreementPartyAssets';


-- 🔁 Rollback for PL/SQL V15.15.2.0.0.2__COL-58813.sql
ALTER TABLE F3JOB DROP COLUMN archiveData;
-- ⚠️ MANUAL CHECK REQUIRED: Cannot revert data updates
-- EXECUTE IMMEDIATE 'update F3JOB set archivedata = 0 where archivedata is null';
DELETE FROM lrsSchemaProperties WHERE moduleName = 'task_scheduler' AND propertyName = 'COL_9999_add_archive_data_column';
