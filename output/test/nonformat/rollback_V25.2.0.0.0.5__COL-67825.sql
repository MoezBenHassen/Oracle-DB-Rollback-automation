-- ð Rollback of V25.2.0.0.0.5__COL-67825.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: column_count NUMBER;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: id_column_count NUMBER;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: v_sql        VARCHAR2(2000);
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: SELECT
COUNT(1)
INTO
column_count
FROM
user_tab_columns
WHERE
table_name  = 'COLAGREEMENTCROSSGROUP'
AND     column_name = 'XXX_DAT_CRE';
-- â ï¸ MANUAL CHECK REQUIRED: EXECUTE IMMEDIATE using unknown or uncaptured variable 'v_sql'
-- ORIGINAL: EXECUTE IMMEDIATE v_sql;
ALTER TABLE colagreementcrossgroup DROP COLUMN xxx_dat_upd;
-- â ï¸ Revert: Cannot determine previous values for UPDATE from variable 'v_sql'
-- ORIGINAL EXEC IMMEDIATE: update colagreementcrossgroup set XXX_DAT_CRE = SYSDATE, XXX_DAT_UPD = SYSDATE
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_sql': ALTER TABLE colagreementcrossgroup  MODIFY (XXX_DAT_CRE DATE NOT NULL)
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_sql': ALTER TABLE colagreementcrossgroup  MODIFY (XXX_DAT_UPD NOT NULL)
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: dbms_output.put_line( '--5-creating audit trigger for colagreementcrossgroup'  );
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: create_table_audit_trigger('colagreementcrossgroup');
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: dbms_output.put_line( '--6-creating index for colagreementcrossgroup'  );
-- â ï¸ Unrecognized EXECUTE IMMEDIATE content from variable 'v_sql': ALTER TABLE colagreementcrossgroup  MODIFY (XXX_DAT_UPD NOT NULL)
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: dbms_output.put_line( 'colagreementcrossgroup migration is done');
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-67825-AddAuditColumnsFor_agreementcrossgroup';
