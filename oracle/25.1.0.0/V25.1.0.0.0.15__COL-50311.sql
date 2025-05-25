DECLARE
 RESULTS NUMBER;
 V_MODULE VARCHAR2(100) := 'COLLATERAL';
 V_PROPERTY VARCHAR2(100) := 'COL50311_CAction';
BEGIN

 SELECT COUNT(1)
   INTO RESULTS
   FROM LRSSCHEMAPROPERTIES L
  WHERE L.MODULENAME = V_MODULE
    AND L.PROPERTYNAME = V_PROPERTY;

 IF RESULTS > 0 THEN
   RETURN;
 END IF;



EXECUTE IMMEDIATE 'CREATE TABLE ColCorporateAction (
                         ID NUMBER(19,0)  PRIMARY KEY,
                         securityId NUMBER(19,0),
                         corporateAction NUMBER(19,0),
                         corporateActionDate TIMESTAMP(9)
                     )';
EXECUTE IMMEDIATE 'CREATE SEQUENCE ColCorporateAction_SEQ increment by 50 cache 10 start with 1';
EXECUTE IMMEDIATE 'Create index idx_ColCorporateActionSecId on ColCorporateAction (securityId)';




INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);

commit;
end;