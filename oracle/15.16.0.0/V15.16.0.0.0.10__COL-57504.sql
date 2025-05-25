DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-57504_ADD_ASSETSERVICE_CLIENT_TAB';
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

EXECUTE IMMEDIATE 'ALTER TABLE ColAgreementHeader ADD longBoxAgreementId NUMBER(19,0) DEFAULT 0 NOT NULL';
EXECUTE IMMEDIATE 'ALTER TABLE ColAgreementHeader ADD autoUpdatePosition NUMBER(1) DEFAULT 1 NOT NULL';

EXECUTE IMMEDIATE '	CREATE INDEX "LONGBOXAGRID_IDX" ON ColAgreementHeader (longBoxAgreementId)';

  INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
  COMMIT;
END;
/



