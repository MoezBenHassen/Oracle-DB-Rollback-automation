DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'Collateral';
  v_property VARCHAR2(100) := 'COL-65208_Duplicated_Privilege';
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

  delete from roleprivileges where privilege = 'collateral.tag.exceed.amount' and description = 'Auto Tagging';
  insert into lrsSchemaProperties(moduleName, propertyName) values(v_module, v_property);

  COMMIT;
END;
/