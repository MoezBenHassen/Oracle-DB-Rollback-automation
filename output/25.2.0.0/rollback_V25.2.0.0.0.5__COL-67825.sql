-- 🔁 Rollback of V25.2.0.0.0.5__COL-67825.sql
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-67825-AddAuditColumnsFor_agreementcrossgroup' ;
