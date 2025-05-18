-- 🔁 Rollback of V25.2.0.0.0.2__COL-66228.sql
DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-66228_Add_Interest_on_Coupon_Reinvestment_under_the_adjustment_information_section';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE coltradesrepo DROP COLUMN interestOnCouponReinvestmentSecCcy';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE coltradesrepo DROP COLUMN interestOnCouponReinvestmentAgrCcy';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE coltradesrepocalc DROP COLUMN interestOnCouponReinvestmentSecCcy';
  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE coltradesrepocalc DROP COLUMN interestOnCouponReinvestmentAgrCcy';

  -- Revert: DELETE inserted row
  DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;
COMMIT;
