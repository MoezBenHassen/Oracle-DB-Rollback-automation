-- ð Rollback of V15.14.0.0.0.5__COL-51352.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:   and l.propertyname = 'COL-52623_Add3_fields_to_Family_statement';
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52623_Add3_fields_to_Family_statement';
