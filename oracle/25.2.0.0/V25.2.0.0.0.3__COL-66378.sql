DECLARE
 RESULTS NUMBER;
 V_MODULE VARCHAR2(100) := 'collateralreports';
 V_PROPERTY VARCHAR2(100) := 'COL-66378_ASR_New_Column_ExcludeFlushed';
BEGIN

 SELECT COUNT(1)
   INTO RESULTS
   FROM LRSSCHEMAPROPERTIES L
  WHERE L.MODULENAME = V_MODULE
    AND L.PROPERTYNAME = V_PROPERTY;

 IF RESULTS > 0 THEN
   RETURN;
 END IF;

  EXECUTE IMMEDIATE 'ALTER TABLE ColRptInAssetSettlement ADD excludeFlushed VARCHAR2(5)';
  EXECUTE IMMEDIATE 'UPDATE ColRptInAssetSettlement SET excludeFlushed=''No''';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);

commit;
end;