-- 🔁 Rollback of V25.2.0.0.0.1__COL-66227.sql
-- ⚠️ MANUAL CHECK REQUIRED for INSERT without explicit columns list (variable substitution might be incomplete):
-- ORIGINAL: insert into moezTest values (3, 'SSS', 'ccc', '456 Oak St', 'tunisia8');
-- POTENTIAL ROLLBACK (assumes column order and requires verification): DELETE FROM  WHERE ... values ( 3,'SSS','ccc','456 Oak St','tunisia8' );
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-66227_Include_Interest_On_Coupon_Reinvestment_To_The_MtM_Calc' ;
