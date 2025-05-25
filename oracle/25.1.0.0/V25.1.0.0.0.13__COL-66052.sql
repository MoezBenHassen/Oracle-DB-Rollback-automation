DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-66052_Corp_action_fields_not_displayed_in_LongBox_agr';
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

    EXECUTE IMMEDIATE 'UPDATE ColagreementHeader SET corporateActionPeriod = ''0'' WHERE corporateActionPeriod IS NULL';
    insert into lrsSchemaProperties(moduleName, propertyName) values(v_module, v_property);

  COMMIT;
END;
/