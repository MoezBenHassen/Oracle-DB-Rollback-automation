DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
v_property VARCHAR2(100) := 'COL-60158_Asset_Settlement_Report_S6';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
AND l.propertyname = v_property;

IF results > 0
THEN
RETURN;
END IF;
EXECUTE IMMEDIATE 'ALTER TABLE colrptoutassetsettlement ADD ownerAgreementAmount float(126) DEFAULT 0 ';
EXECUTE IMMEDIATE 'ALTER TABLE colrptoutassetsettlement ADD inventorySource varchar(200) ';
EXECUTE IMMEDIATE 'ALTER TABLE colrptoutassetsettlement ADD inventorySourceAmount float(126) DEFAULT 0 ';


INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
