-- 🔁 Rollback of V25.2.0.0.0.2__COL-66228.sql
ALTER TABLE coltradesrepo DROP COLUMN interestOnCouponReinvestmentSecCcy;
ALTER TABLE coltradesrepo DROP COLUMN interestOnCouponReinvestmentAgrCcy;
ALTER TABLE coltradesrepocalc DROP COLUMN interestOnCouponReinvestmentSecCcy;
ALTER TABLE coltradesrepocalc DROP COLUMN interestOnCouponReinvestmentAgrCcy;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-66228_Add_Interest_on_Coupon_Reinvestment_under_the_adjustment_information_section' ;
