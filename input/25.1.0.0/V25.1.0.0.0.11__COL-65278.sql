DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'reports';
    v_property VARCHAR2(100) := 'COL-64725_S4_Enhance_Collateral_Availability_report_to_support_PDG_IDG_configuration';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutCollateralAvalty
ADD (INVENTORYDELIVERYGROUP VARCHAR2(250), PRINCIPALDELIVERYGROUP VARCHAR2(250))';


INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
