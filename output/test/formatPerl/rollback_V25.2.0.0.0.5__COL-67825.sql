-- ð Rollback of V25.2.0.0.0.5__COL-67825.sql
ALTER TABLE colagreementcrossgroup DROP COLUMN xxx_dat_cre;
ALTER TABLE colagreementcrossgroup DROP COLUMN xxx_dat_upd;
-- â ï¸ Revert: Cannot determine previous values for UPDATE from variable 'v_sql'
-- ORIGINAL EXEC IMMEDIATE: update colagreementcrossgroup set XXX_DAT_CRE = SYSDATE, XXX_DAT_UPD = SYSDATE
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_sql': ALTER TABLE colagreementcrossgroup  MODIFY (XXX_DAT_CRE DATE NOT NULL)
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_sql': ALTER TABLE colagreementcrossgroup  MODIFY (XXX_DAT_UPD NOT NULL)
DROP INDEX idx_colagrcrossgroup_dat_upd;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-67825-AddAuditColumnsFor_agreementcrossgroup';
