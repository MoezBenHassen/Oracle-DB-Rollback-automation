DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-52834_Add_agency_field_and_bookingTrigger_fields';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;
EXECUTE IMMEDIATE 'ALTER TABLE ColEligRulesDetails  ADD agency VARCHAR2(50)';
EXECUTE IMMEDIATE 'ALTER TABLE ColEligRulesDetails  ADD bookingTrigger NUMBER(1) DEFAULT 1 NOT NULL';
EXECUTE IMMEDIATE 'ALTER TABLE ColEligRulesDetailsHistory  ADD agency VARCHAR2(50)';
EXECUTE IMMEDIATE 'ALTER TABLE ColEligRulesDetailsHistory  ADD bookingTrigger NUMBER(1) DEFAULT 1 NOT NULL';
EXECUTE IMMEDIATE 'ALTER TABLE coleligconclimitclassrule  ADD agency VARCHAR2(50)';
EXECUTE IMMEDIATE 'ALTER TABLE coleligconclimitclassrule  ADD bookingTrigger NUMBER(1) DEFAULT 1 NOT NULL';
EXECUTE IMMEDIATE 'ALTER TABLE ColEligConcLimitClassRulehis  ADD agency VARCHAR2(50)';
EXECUTE IMMEDIATE 'ALTER TABLE ColEligConcLimitClassRulehis  ADD bookingTrigger NUMBER(1) DEFAULT 1 NOT NULL';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
