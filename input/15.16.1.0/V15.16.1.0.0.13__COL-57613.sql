DECLARE
results NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-57613';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;
EXECUTE IMMEDIATE 'ALTER TABLE F3JOB  ADD ASSETSERVICEROLE VARCHAR2(50)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
