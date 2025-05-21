-- 🔁 Rollback of V25.2.0.0.0.2__COL-66228.sql
ALTER TABLE coltradesrepo DROP COLUMN interestoncouponreinvestmentsecccy;
ALTER TABLE coltradesrepo DROP COLUMN interestoncouponreinvestmentagrccy;
ALTER TABLE coltradesrepocalc DROP COLUMN interestoncouponreinvestmentsecccy;
ALTER TABLE coltradesrepocalc DROP COLUMN interestoncouponreinvestmentagrccy;
DELETE FROM lrsschemaproperties WHERE modulename = 'v_module' AND propertyname = 'v_property' ;
