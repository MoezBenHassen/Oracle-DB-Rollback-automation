-- ð Rollback of V15.14.0.0.0.4__COL-51258.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:     IF results > 0
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:     THEN
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-51258_S2_Products_tab';
