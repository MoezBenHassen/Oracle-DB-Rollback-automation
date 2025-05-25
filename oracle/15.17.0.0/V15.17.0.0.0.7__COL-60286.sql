DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-60286_OPT_Result_Report';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutOptResult add approval  varchar2 (50) ';
EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutOptResult add originator  varchar2 (250) ';
EXECUTE IMMEDIATE 'ALTER TABLE ColRptOutOptResult add nameFormat  varchar2 (1024) ';

EXECUTE IMMEDIATE 'ALTER TABLE OPT_RUNRESULT add originator varchar2(250) ';



INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
