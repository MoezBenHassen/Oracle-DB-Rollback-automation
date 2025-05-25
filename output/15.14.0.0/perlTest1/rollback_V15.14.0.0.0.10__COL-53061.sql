-- ð Rollback of V15.14.0.0.0.10__COL-53061.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:     and l.propertyname = 'COL-53061_cancellation_code';
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-53061_cancellation_code';
