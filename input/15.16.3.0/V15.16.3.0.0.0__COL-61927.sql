DECLARE
 RESULTS NUMBER;
 V_MODULE VARCHAR2(100) := 'collateralReports';
 V_PROPERTY VARCHAR2(100) := 'COL-61927_Colline_crashes_when_saving_agreement_report';
BEGIN

 SELECT COUNT(1)
   INTO RESULTS
   FROM LRSSCHEMAPROPERTIES L
  WHERE L.MODULENAME = V_MODULE
    AND L.PROPERTYNAME = V_PROPERTY;

 IF RESULTS > 0 THEN
   RETURN;
 END IF;

 EXECUTE IMMEDIATE 'Alter table COLRPTOUTAGREEMENTS add prinTargetBuffer varchar2(50)';
 EXECUTE IMMEDIATE 'Alter table COLRPTOUTAGREEMENTS add cptytargetbuffer varchar2(50)';
 EXECUTE IMMEDIATE 'Alter table COLRPTOUTAGREEMENTS add imPrinTargetBuffer varchar2(50)';
 EXECUTE IMMEDIATE 'Alter table COLRPTOUTAGREEMENTS add imcptyTargetBuffer varchar2(50)';

 INSERT INTO LRSSCHEMAPROPERTIES(MODULENAME, PROPERTYNAME) VALUES(V_MODULE,V_PROPERTY);

 COMMIT;

END;
/