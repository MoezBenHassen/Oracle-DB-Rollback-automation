-- ð Rollback of V25.2.0.0.0.5__COL-67825.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: IF
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:  results > 0 
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: THEN
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: END 
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: IF
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: ;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: IF
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:  column_count = 0 
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: THEN
ALTER TABLE colagreementcrossgroup DROP COLUMN xxx_dat_cre;
ALTER TABLE colagreementcrossgroup DROP COLUMN xxx_dat_upd;
-- â ï¸ Revert: Cannot determine previous values for UPDATE from variable 'v_sql'
-- ORIGINAL EXEC IMMEDIATE: update colagreementcrossgroup set XXX_DAT_CRE = SYSDATE, XXX_DAT_UPD = SYSDATE
-- â ï¸ Revert: Consider allowing NULLs again on table colagreementcrossgroup (from variable 'v_sql' modifying to NOT NULL)
-- ORIGINAL EXEC IMMEDIATE: ALTER TABLE colagreementcrossgroup MODIFY (XXX_DAT_CRE DATE NOT NULL)
-- â ï¸ Revert: Consider allowing NULLs again on table colagreementcrossgroup (from variable 'v_sql' modifying to NOT NULL)
-- ORIGINAL EXEC IMMEDIATE: ALTER TABLE colagreementcrossgroup MODIFY (XXX_DAT_UPD NOT NULL)
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: dbms_output.put_line( ' 
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: IF
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: THEN
DROP INDEX idx_colagrcrossgroup_dat_upd;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: END 
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: IF
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: ;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: END 
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: IF
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: ;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-67825-AddAuditColumnsFor_agreementcrossgroup';
