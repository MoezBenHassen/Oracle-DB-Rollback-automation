-- 🔁 Rollback of V25.2.0.0.0.3__COL-66378.sql
ALTER TABLE colrptinassetsettlement DROP COLUMN excludeflushed;
-- ⚠️ MANUAL CHECK REQUIRED: the following UPDATE needs to be manually rolledback
-- ORIGINAL: EXECUTE IMMEDIATE 'UPDATE ColRptInAssetSettlement SET excludeFlushed=''No''';
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-66228_Add_Interest_on_Coupon_Reinvestment_under_the_adjustment_information_section' ;
