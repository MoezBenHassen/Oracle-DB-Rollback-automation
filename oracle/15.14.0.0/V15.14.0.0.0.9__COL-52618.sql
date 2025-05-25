DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL52618_S1_Add_Brt_Fields';
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

EXECUTE IMMEDIATE 'Alter table COLBOOKINGRULESTEMP add NettingIaAndMtm NUMBER(1) DEFAULT 2';
EXECUTE IMMEDIATE 'Alter table COLBOOKINGRULESTEMP add CashflowRules NUMBER(1,0) DEFAULT 0';
EXECUTE IMMEDIATE 'Alter table COLBOOKINGRULESDETAIL add Value NUMBER(1) DEFAULT -1';

EXECUTE IMMEDIATE 'Alter table COLBOOKINGRULESTEMP add businessLineV2 VARCHAR(255)';
EXECUTE IMMEDIATE 'Update COLBOOKINGRULESTEMP set businessLineV2 = CAST(businessLine AS VARCHAR(255))';
EXECUTE IMMEDIATE 'Alter table COLBOOKINGRULESTEMP drop column BusinessLine';
EXECUTE IMMEDIATE 'Alter table COLBOOKINGRULESTEMP rename column businessLineV2 to businessLine';


  INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
  COMMIT;
END;
/