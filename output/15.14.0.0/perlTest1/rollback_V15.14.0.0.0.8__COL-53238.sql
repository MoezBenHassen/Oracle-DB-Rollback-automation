-- ð Rollback of V15.14.0.0.0.8__COL-53238.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: IF results > 0
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:   THEN
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-53238_settlement_date_and_split_settlement_date';
