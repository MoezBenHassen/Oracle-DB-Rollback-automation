DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'reports';
  v_property VARCHAR2(100) := 'COL-57608_Add_New_Asset_Service_Role';
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

EXECUTE IMMEDIATE 'alter table ColRptOutStatement add assetServiceRole varchar(250) default ''Client''';
EXECUTE IMMEDIATE 'alter table ColRptInStatement add assetServiceRole varchar(250) default ''Client''';

EXECUTE IMMEDIATE 'alter table COLRPTOUTAGREEMENTS add assetServiceAgreements varchar(250)';
EXECUTE IMMEDIATE 'alter table COLRPTOUTAGREEMENTS add clientAgreements varchar(250)';
EXECUTE IMMEDIATE 'alter table COLRPTOUTAGREEMENTS add autoUpdatePosition varchar(50)';

EXECUTE IMMEDIATE 'alter table ColRptOutAgreementAudit add assetServiceAgreements varchar(250)';
EXECUTE IMMEDIATE 'alter table ColRptOutAgreementAudit add clientAgreements varchar(250)';
EXECUTE IMMEDIATE 'alter table ColRptOutAgreementAudit add autoUpdatePosition varchar(50)';

insert into lrsSchemaProperties(moduleName, propertyName) values('reports', 'COL-57608_Add_New_Asset_Service_Role');

COMMIT;
END;
/