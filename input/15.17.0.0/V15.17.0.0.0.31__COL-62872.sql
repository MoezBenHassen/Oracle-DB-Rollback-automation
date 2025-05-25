DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-62872_UPDATE_COLFIRMPOSITION_WITH_FEEDTIME';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'ALTER TABLE COLFIRMPOSITION ADD FEEDTIME TIMESTAMP';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
