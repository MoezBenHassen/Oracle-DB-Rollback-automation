DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-55454_Add_splitSettPeriod_field';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'ALTER TABLE COLRPTOUTAGREEMENTS  ADD SPLITSETTLEMENTPERIOD  VARCHAR2(100)';
EXECUTE IMMEDIATE 'ALTER TABLE COLRPTOUTAGREEMENTS  MODIFY ASSETS  VARCHAR2(4000)';
INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/