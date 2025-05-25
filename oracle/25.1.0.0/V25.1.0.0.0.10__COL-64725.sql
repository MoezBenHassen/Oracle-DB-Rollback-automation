DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'reports';
    v_property VARCHAR2(100) := 'COL-64725_S1_Enhance_Existing_Collateral_Availability_Report';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutCollateralAvalty ADD concentrationRuleMin varchar2(1000)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
