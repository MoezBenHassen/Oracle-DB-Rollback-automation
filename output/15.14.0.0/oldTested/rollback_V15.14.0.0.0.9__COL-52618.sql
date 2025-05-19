-- 🔁 Rollback of V15.14.0.0.0.9__COL-52618.sql
ALTER TABLE colbookingrulestemp DROP COLUMN nettingiaandmtm;
ALTER TABLE colbookingrulestemp DROP COLUMN cashflowrules;
ALTER TABLE colbookingrulesdetail DROP COLUMN value;
ALTER TABLE colbookingrulestemp DROP COLUMN businesslinev2;
-- ⚠️ MANUAL CHECK REQUIRED: the following UPDATE needs to be manually rolledback
-- ORIGINAL: EXECUTE IMMEDIATE 'Update COLBOOKINGRULESTEMP set businessLineV2 = CAST(businessLine AS VARCHAR(255))';
-- ⚠️ MANUAL CHECK REQUIRED: CASE NOT HANDLED
-- ORIGINAL: EXECUTE IMMEDIATE 'Alter table COLBOOKINGRULESTEMP drop column BusinessLine';
-- ⚠️ MANUAL CHECK REQUIRED: CASE NOT HANDLED
-- ORIGINAL: EXECUTE IMMEDIATE 'Alter table COLBOOKINGRULESTEMP rename column businessLineV2 to businessLine';
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL52618_S1_Add_Brt_Fields' ;
