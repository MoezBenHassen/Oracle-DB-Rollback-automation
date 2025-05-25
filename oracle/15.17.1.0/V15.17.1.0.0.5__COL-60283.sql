DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-60283_Add_imSource_To_bookings';
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

  EXECUTE IMMEDIATE 'ALTER TABLE OPTBOOKING ADD (SOURCEID NUMBER(19), INVENTORYDELIVERYGROUP NUMBER(19))';


  INSERT INTO lrsSchemaProperties(moduleName, propertyName) VALUES(v_module, v_property);

  COMMIT;
END;
/