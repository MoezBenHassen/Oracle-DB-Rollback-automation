DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
v_property VARCHAR2(100) := 'COL-51927_AddLongBoxFieldsToStaticData';
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


EXECUTE IMMEDIATE 'alter table REFDATA add (isLongBox NUMBER DEFAULT 0,inventoryDG VARCHAR2(100) DEFAULT null,inventoryManagerSS NUMBER DEFAULT 0)';
EXECUTE IMMEDIATE 'alter table COLREFDATA add (isLongBox NUMBER DEFAULT 0,inventoryDG VARCHAR2(100) DEFAULT null,inventoryManagerSS NUMBER DEFAULT 0)';
EXECUTE IMMEDIATE 'alter table ORGREFDATA add (isLongBox NUMBER DEFAULT 0,inventoryDG VARCHAR2(100) DEFAULT null,inventoryManagerSS NUMBER DEFAULT 0)';
EXECUTE IMMEDIATE 'alter table UDFVALUESREFDATA add (isLongBox NUMBER DEFAULT 0,inventoryDG VARCHAR2(100) DEFAULT null,inventoryManagerSS NUMBER DEFAULT 0)';
EXECUTE IMMEDIATE 'alter table TRADINGREFDATA add (isLongBox NUMBER DEFAULT 0,inventoryDG VARCHAR2(100) DEFAULT null,inventoryManagerSS NUMBER DEFAULT 0)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
