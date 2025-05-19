-- 🔁 Rollback of V25.2.0.0.0.5__COL-67825.sql
-- ⚠️ MANUAL CHECK REQUIRED: CASE NOT HANDLED
-- ORIGINAL: create_table_audit_trigger('colagreementcrossgroup');
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-67825-AddAuditColumnsFor_agreementcrossgroup' ;
