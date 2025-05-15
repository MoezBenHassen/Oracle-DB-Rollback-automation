-- 🔁 Rollback of V25.2.0.0.0.3__COL-66378.sql
DECLARE
 RESULTS NUMBER;
 V_MODULE VARCHAR2(100) := 'collateralreports';
 V_PROPERTY VARCHAR2(100) := 'COL-66378_ASR_New_Column_ExcludeFlushed';
BEGIN

 SELECT COUNT(1)
   INTO RESULTS
   FROM LRSSCHEMAPROPERTIES L
  WHERE L.MODULENAME = V_MODULE
    AND L.PROPERTYNAME = V_PROPERTY;

 IF RESULTS > 0 THEN
   RETURN;
 END IF;

  -- Revert: DROP added column (from EXECUTE IMMEDIATE)
  EXECUTE IMMEDIATE 'ALTER TABLE ColRptInAssetSettlement DROP COLUMN excludeFlushed';
  EXECUTE IMMEDIATE 'UPDATE ColRptInAssetSettlement SET excludeFlushed=''No''';

  -- Revert: DELETE inserted row
  DELETE FROM lrsschemaproperties WHERE modulename = v_module AND propertyname = v_property ;

commit;
