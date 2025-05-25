DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'Collateral';
  v_property VARCHAR2(100) := 'COL-56605_Add_Auto_Tag_Privilege';
  maxId NUMBER;
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

  SELECT max(id) INTO maxId FROM roleprivileges;

  insert into roleprivileges (id, privilege, rolename, description) values (maxid+1,'collateral.tag.exceed.amount', 'admin', 'Auto Tagging');
  insert into lrsSchemaProperties(moduleName, propertyName) values(v_module, v_property);

  COMMIT;
END;
/