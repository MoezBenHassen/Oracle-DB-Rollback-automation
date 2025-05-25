DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'reports';
    v_property VARCHAR2(100) := 'COL-64726_S2_Enhance_Collateral_Availability_report_to_support_ERT_ERTC';

BEGIN
SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'CREATE INDEX idx_eligibility_assetclass ON coleligconclimitclassrulehis(eligibilityrulehistoryid, assetclassid)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;