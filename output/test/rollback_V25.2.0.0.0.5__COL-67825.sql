-- 🔁 Rollback of V25.2.0.0.0.5__COL-67825.sql
ALTER TABLE colagreementcrossgroup DROP COLUMN xxx_dat_cre;
ALTER TABLE colagreementcrossgroup DROP COLUMN xxx_dat_upd;
-- ⚠️ Revert: Cannot determine previous values for UPDATE on colagreementcrossgroup (from variable v_sql)
-- ORIGINAL: update colagreementcrossgroup set XXX_DAT_CRE = SYSDATE, XXX_DAT_UPD = SYSDATE
-- ⚠️ Revert: Consider allowing NULLs again on colagreementcrossgroup (from variable v_sql)
-- ⚠️ Revert: Consider allowing NULLs again on colagreementcrossgroup (from variable v_sql)
-- ⚠️ MANUAL CHECK REQUIRED: CASE NOT HANDLED
-- ORIGINAL: create_table_audit_trigger('colagreementcrossgroup');
DROP INDEX idx_colagrcrossgroup_dat_upd;
DELETE FROM lrsschemaproperties WHERE modulename = 'v_module' AND propertyname = 'v_property' ;
