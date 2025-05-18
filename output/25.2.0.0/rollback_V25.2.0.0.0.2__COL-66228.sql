-- 🔁 Rollback of V25.2.0.0.0.2__COL-66228.sql
ALTER TABLE coltradesrepo DROP COLUMN interestOnCouponReinvestmentSecCcy;
ALTER TABLE coltradesrepo DROP COLUMN interestOnCouponReinvestmentAgrCcy;
ALTER TABLE coltradesrepocalc DROP COLUMN interestOnCouponReinvestmentSecCcy;
ALTER TABLE coltradesrepocalc DROP COLUMN interestOnCouponReinvestmentAgrCcy;
DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;
