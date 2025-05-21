-- 🔁 Rollback of V25.2.0.0.0.2__COL-66228.sql
ALTER TABLE coltradesrepo DROP COLUMN interestoncouponreinvestmentsecccy;
ALTER TABLE coltradesrepo DROP COLUMN interestoncouponreinvestmentagrccy;
ALTER TABLE coltradesrepocalc DROP COLUMN interestoncouponreinvestmentsecccy;
ALTER TABLE coltradesrepocalc DROP COLUMN interestoncouponreinvestmentagrccy;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-66228_Add_Interest_on_Coupon_Reinvestment_under_the_adjustment_information_section' ;
