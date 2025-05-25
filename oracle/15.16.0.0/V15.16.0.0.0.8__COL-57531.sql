DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-57531_Multiple_InventoryDG';
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

EXECUTE IMMEDIATE 'CREATE TABLE ColAgreementInventoryDeliveryGroup (agreementId NUMBER(19,0) NOT NULL,inventoryDeliveryGroup NUMBER(19,0) NOT NULL,assetServiceRole NUMBER(1,0), PRIMARY KEY (agreementId, inventoryDeliveryGroup))';
EXECUTE IMMEDIATE 'INSERT INTO ColAgreementInventoryDeliveryGroup (agreementId, inventoryDeliveryGroup,assetServiceRole) SELECT id, inventoryDeliveryGroup, assetServiceRole FROM ColAgreementHeader WHERE inventoryDeliveryGroup != 0';

EXECUTE IMMEDIATE 'ALTER TABLE ColAgreementHeader DROP COLUMN inventoryDeliveryGroup';

EXECUTE IMMEDIATE 'CREATE INDEX agreementId_idx ON ColAgreementInventoryDeliveryGroup (agreementId)';

  INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
  COMMIT;
END;
/



