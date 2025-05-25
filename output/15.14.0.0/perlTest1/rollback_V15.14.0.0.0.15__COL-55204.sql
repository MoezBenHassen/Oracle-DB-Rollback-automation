-- ð Rollback of V15.14.0.0.0.15__COL-55204.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: IF results > 0
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:     THEN
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-55204_Add_collineIssueSubs_field';
