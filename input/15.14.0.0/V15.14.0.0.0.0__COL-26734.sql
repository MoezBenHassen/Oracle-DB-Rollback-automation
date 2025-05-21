DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-26734_updateUdfMaxValue';

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

EXECUTE IMMEDIATE 'alter table COLRPTOUTASSETSETTLEMENT modify USER_DEFINED_FIELD VARCHAR(1000)';
EXECUTE IMMEDIATE 'alter table COLAGREEMENTUSERDEFINEDFIELDS modify UDFVALUE VARCHAR(1000)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);

COMMIT;
END;
/