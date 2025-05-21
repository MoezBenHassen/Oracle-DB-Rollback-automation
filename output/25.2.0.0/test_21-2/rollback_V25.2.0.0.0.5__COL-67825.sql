-- 🔁 Rollback of V25.2.0.0.0.5__COL-67825.sql
ALTER TABLE colagreementcrossgroup DROP COLUMN xxx_dat_cre;
ALTER TABLE colagreementcrossgroup DROP COLUMN xxx_dat_upd;
-- ⚠️ Revert: Cannot determine previous values for UPDATE on colagreementcrossgroup (from variable v_sql)
-- ORIGINAL EXEC IMMEDIATE: update colagreementcrossgroup set XXX_DAT_CRE = SYSDATE, XXX_DAT_UPD = SYSDATE
-- ⚠️ Revert: Consider allowing NULLs again on colagreementcrossgroup (from variable v_sql modifying to NOT NULL)
-- ORIGINAL EXEC IMMEDIATE: ALTER TABLE colagreementcrossgroup  MODIFY (XXX_DAT_CRE DATE NOT NULL)
-- ⚠️ Revert: Consider allowing NULLs again on colagreementcrossgroup (from variable v_sql modifying to NOT NULL)
-- ORIGINAL EXEC IMMEDIATE: ALTER TABLE colagreementcrossgroup  MODIFY (XXX_DAT_UPD NOT NULL)
DROP INDEX idx_colagrcrossgroup_dat_upd;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-67825-AddAuditColumnsFor_agreementcrossgroup' ;
