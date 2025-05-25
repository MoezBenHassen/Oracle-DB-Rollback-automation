DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-64708_corporate_actionS9';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
AND l.propertyname = v_property;

IF results > 0
THEN
RETURN;
END IF;

EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutCorpActions ADD daysToCorporateAction varchar(25) ';
EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutCorpActions ADD corporateActionDate TIMESTAMP(9) ';

EXECUTE IMMEDIATE 'alter table COLRPTOUTAGREEMENTS add substitutionDayCount varchar(25) ';
EXECUTE IMMEDIATE 'alter table COLRPTOUTAGREEMENTS add corporateActionPeriod varchar(250) ';

EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutSecurity ADD corporateAction varchar(20)';
EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutSecurity ADD corporateActionDate TIMESTAMP(9)';


INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;