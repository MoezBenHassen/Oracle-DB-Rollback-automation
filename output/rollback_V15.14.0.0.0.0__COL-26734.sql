-- 🔁 Rollback of V15.14.0.0.0.0__COL-26734.sql
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

  -- MODIFY inside EXECUTE IMMEDIATE detected, manual revert required
  -- EXECUTE IMMEDIATE 'alter table COLRPTOUTASSETSETTLEMENT modify USER_DEFINED_FIELD VARCHAR(1000)';
  -- MODIFY inside EXECUTE IMMEDIATE detected, manual revert required
  -- EXECUTE IMMEDIATE 'alter table COLAGREEMENTUSERDEFINEDFIELDS modify UDFVALUE VARCHAR(1000)';

  -- Revert: DELETE inserted row
  DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;

COMMIT;
END;
