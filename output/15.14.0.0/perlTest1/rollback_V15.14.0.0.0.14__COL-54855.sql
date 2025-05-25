-- ð Rollback of V15.14.0.0.0.14__COL-54855.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: IF results > 0
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:   THEN
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-54855_fix size INTERESTPAY in FEED_STAGING_GOOD_AGREEMENT';
