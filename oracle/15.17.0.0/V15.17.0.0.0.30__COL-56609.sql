DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL_56609_rehypo_from_ColSecurityParamount';
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

  EXECUTE IMMEDIATE 'alter table ColSecurityParamount add rehypoFrom number(19) default 0 not null';

  insert into lrsSchemaProperties(moduleName, propertyName) values(v_module, v_property);

  COMMIT;
END;
/