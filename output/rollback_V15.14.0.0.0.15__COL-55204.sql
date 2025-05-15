-- 🔁 Rollback of V15.14.0.0.0.15__COL-55204.sql
DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-55204_Add_collineIssueSubs_field';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE COLWORKFLOWINTERFACEREF DROP COLUMN COLLINEISSUESUBS';
  -- Revert: DELETE inserted row
  DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;
COMMIT;
END;
