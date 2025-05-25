DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-56608_Inventory_Source_available';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;
EXECUTE IMMEDIATE 'create index TAGGED_DELIVERY_PARAMOUNT_COLSECURITYPARAMOUNT on ColSecurityParAmount(agreementId,movement,ownerAgreement,imSource,flushed,settlementStatus ) ';
EXECUTE IMMEDIATE 'create index TAGGED_DELIVERY_PARAMOUNT_COLSECURITYINFO on ColSecurities(shortname )';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;





