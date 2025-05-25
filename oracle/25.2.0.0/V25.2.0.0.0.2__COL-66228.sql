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

EXECUTE IMMEDIATE 'ALTER TABLE coltradesrepo ADD interestOnCouponReinvestmentSecCcy FLOAT DEFAULT 0';
EXECUTE IMMEDIATE 'ALTER TABLE coltradesrepo ADD interestOnCouponReinvestmentAgrCcy FLOAT DEFAULT 0';
EXECUTE IMMEDIATE 'ALTER TABLE coltradesrepocalc ADD interestOnCouponReinvestmentSecCcy FLOAT DEFAULT 0';
EXECUTE IMMEDIATE 'ALTER TABLE coltradesrepocalc ADD interestOnCouponReinvestmentAgrCcy FLOAT DEFAULT 0';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;