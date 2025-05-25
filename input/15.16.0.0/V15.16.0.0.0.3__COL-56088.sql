
DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-56088_agency_field_bookingTrigger_fields';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutEligRuleTemplate  ADD AGENCY VARCHAR2(200)';
EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutEligRuleTemplate  ADD BOOKINGTRIGGER NUMBER(1) DEFAULT 1 NOT NULL';
INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/