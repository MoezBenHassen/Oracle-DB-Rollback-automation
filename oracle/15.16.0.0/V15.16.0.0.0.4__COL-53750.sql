DECLARE
 results NUMBER;
 v_module VARCHAR2(100) := 'collateral';
 v_property VARCHAR2(100) := 'COL-53750_S1_Add_filterValueL2_Field';
BEGIN



SELECT count(1)
INTO results
 FROM lrsschemaproperties l
 WHERE l.modulename = v_module
 AND l.propertyname = v_property;



IF results > 0
THEN
RETURN;
END IF;

EXECUTE IMMEDIATE  'ALTER TABLE ColEligRulesParameters ADD filterValueL2 VARCHAR2(255)';
EXECUTE IMMEDIATE  'ALTER TABLE ColEligrulesParamHistory ADD filterValueL2 VARCHAR2(255)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/