-- ð Rollback of V15.14.0.0.0.12__COL-52633.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: IF results > 0
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:     THEN
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52633_Add_comment_field';
