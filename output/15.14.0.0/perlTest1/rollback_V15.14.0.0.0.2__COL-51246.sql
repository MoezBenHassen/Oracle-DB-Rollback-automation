-- ð Rollback of V15.14.0.0.0.2__COL-51246.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: IF results > 0
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:   THEN
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-51246_S4_Feed_Agreement_Settlement_Tab';
