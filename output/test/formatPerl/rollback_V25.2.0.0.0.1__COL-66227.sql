-- ð Rollback of V25.2.0.0.0.1__COL-66227.sql
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'col-66227_include_interest_on_coupon_reinvestment_to_the_mtm_calc';
