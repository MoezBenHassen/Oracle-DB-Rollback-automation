DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateralreports';
    v_property VARCHAR2(100) := 'COL-60049_Cannot_create_select_Report_Template_under_Asset_Holdings_Valuation_Report';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'ALTER TABLE colrptoutassetholdings DROP COLUMN rejected';
EXECUTE IMMEDIATE 'ALTER TABLE ColRptInAssetHoldings ADD rejected VARCHAR2(50)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
