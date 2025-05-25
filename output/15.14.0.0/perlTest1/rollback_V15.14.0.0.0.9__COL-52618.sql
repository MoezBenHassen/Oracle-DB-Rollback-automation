-- ð Rollback of V15.14.0.0.0.9__COL-52618.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:   IF results > 0
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL:   THEN
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: EXECUTE IMMEDIATE 'Alter table COLBOOKINGRULESDETAIL add Value NUMBER(1) DEFAULT -1';
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL52618_S1_Add_Brt_Fields';
