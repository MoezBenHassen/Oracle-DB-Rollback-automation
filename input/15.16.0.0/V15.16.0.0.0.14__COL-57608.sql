DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'reports';
  v_property VARCHAR2(100) := 'COL57608_addnewAssetServiceRole';
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

  EXECUTE IMMEDIATE 'alter table ColRptInAssetHoldings add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table ColRptOutAssetHoldings add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptinassetmanagement add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutassetmanagement add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptinassetsettlement add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutassetsettlement add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptineligibleasset add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutineligibleasset add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptinfirmposition add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table ColRptOutFirmPosition add assetServiceRole varchar(250) default ''Client''';


  EXECUTE IMMEDIATE 'alter table ColRptInAgreements add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table COLRPTOUTAGREEMENTS add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table ColRptInAgreementAudit add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table ColRptOutAgreementAudit add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptinsettlementinstruction add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutsettlementinstruction add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptintrades add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptouttrades add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptinrejectedtrades add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutrejectedtrades add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptinorgagreement add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutorgagreement add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptinorgthreshold add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutorgthreshold add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptindailyexposure add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutdailyexposure add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptinhistoricalexposure add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptouthistoricalexposure add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptindisputehistory add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutdisputehistory add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptininternalreview add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutinternalreview add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table COLRPTINHISTORICALWORKFLOW add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table COLRPTOUTHISTORICALWORKFLOW add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table ColRptInWhatIfScenario add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutwhatifscenario add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table ColRptInCollateralAvalty add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutcollateralavalty add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptincorpactions add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutcorpactions add assetServiceRole varchar(250) default ''Client''';


  EXECUTE IMMEDIATE 'alter table colrptinconclimit add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutconclimit add assetServiceRole varchar(250) default ''Client''';

  EXECUTE IMMEDIATE 'alter table colrptinclearingtradescom add assetServiceRole varchar(250) default ''Client''';
  EXECUTE IMMEDIATE 'alter table colrptoutclearingtradescom add assetServiceRole varchar(250) default ''Client''';


  insert into lrsSchemaProperties(moduleName, propertyName) values('reports', 'COL57608_addnewAssetServiceRole');

  COMMIT;
END;
/