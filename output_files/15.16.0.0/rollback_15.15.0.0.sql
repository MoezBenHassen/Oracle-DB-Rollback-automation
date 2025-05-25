-- 🔁 Rollback for PL/SQL  V15.16.0.0.0.0__COL51522.sql
DELETE FROM preferences WHERE PARENT = 7 AND PREFTYPE = '(global)' AND NAME = 'REPO OR TBA CONFIG' AND PREFVALUE IS NULL AND PREFCLASS IS NULL;
DELETE FROM lrsSchemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-51522_Adding_repo_or_tba_field_on_Configuration>Preferences';


-- 🔁 Rollback for PL/SQL V15.16.0.0.0.1__COL-56214.sql 
DELETE FROM preferences WHERE PARENT = 7 AND PREFTYPE = '(global)' AND NAME = 'Enable_Booking_At_Parent_Level' AND PREFVALUE = 'false' AND PREFCLASS IS NULL;
DELETE FROM lrsSchemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-56214_Add_Enable_Booking_At_Parent_Level';

-- 🔁 Rollback for PL/SQL V15.16.0.0.0.2__COL-52834.sql
ALTER TABLE ColEligRulesDetails DROP COLUMN agency;
ALTER TABLE ColEligRulesDetails DROP COLUMN bookingTrigger;
ALTER TABLE ColEligRulesDetailsHistory DROP COLUMN agency;
ALTER TABLE ColEligRulesDetailsHistory DROP COLUMN bookingTrigger;
ALTER TABLE coleligconclimitclassrule DROP COLUMN agency;
ALTER TABLE coleligconclimitclassrule DROP COLUMN bookingTrigger;
ALTER TABLE ColEligConcLimitClassRulehis DROP COLUMN agency;
ALTER TABLE ColEligConcLimitClassRulehis DROP COLUMN bookingTrigger;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-52834_Add_agency_field_and_bookingTrigger_fields';

-- 🔁 Rollback for PL/SQL V15.16.0.0.0.3__COL-56088.sql
ALTER TABLE ColRptOutEligRuleTemplate DROP COLUMN AGENCY;
ALTER TABLE ColRptOutEligRuleTemplate DROP COLUMN BOOKINGTRIGGER;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-56088_agency_field_bookingTrigger_fields';

-- 🔁 Rollback for PL/SQL V15.16.0.0.0.4__COL-53750.sql
ALTER TABLE ColEligRulesParameters DROP COLUMN filterValueL2;
ALTER TABLE ColEligrulesParamHistory DROP COLUMN filterValueL2;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-53750_S1_Add_filterValueL2_Field';

-- 🔁 Rollback for PL/SQL V15.16.0.0.0.5__COL-57501.sql
ALTER TABLE COLAGREEMENTHEADER DROP COLUMN ASSETSERVICEROLE;
DELETE FROM LRSSCHEMAPROPERTIES WHERE moduleName = 'COLLATERAL' AND propertyName = 'COL57501_LONGBOX_AGRMT_SETUP';

-- 🔁 Rollback for PL/SQL V15.16.0.0.0.6__COL-51927.sql
ALTER TABLE REFDATA DROP COLUMN isLongBox;
ALTER TABLE REFDATA DROP COLUMN inventoryDG;
ALTER TABLE REFDATA DROP COLUMN inventoryManagerSS;

ALTER TABLE COLREFDATA DROP COLUMN isLongBox;
ALTER TABLE COLREFDATA DROP COLUMN inventoryDG;
ALTER TABLE COLREFDATA DROP COLUMN inventoryManagerSS;

ALTER TABLE ORGREFDATA DROP COLUMN isLongBox;
ALTER TABLE ORGREFDATA DROP COLUMN inventoryDG;
ALTER TABLE ORGREFDATA DROP COLUMN inventoryManagerSS;

ALTER TABLE UDFVALUESREFDATA DROP COLUMN isLongBox;
ALTER TABLE UDFVALUESREFDATA DROP COLUMN inventoryDG;
ALTER TABLE UDFVALUESREFDATA DROP COLUMN inventoryManagerSS;

ALTER TABLE TRADINGREFDATA DROP COLUMN isLongBox;
ALTER TABLE TRADINGREFDATA DROP COLUMN inventoryDG;
ALTER TABLE TRADINGREFDATA DROP COLUMN inventoryManagerSS;

DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-51927_AddLongBoxFieldsToStaticData';

-- 🔁 Rollback for PL/SQL  V15.16.0.0.0.7__COL-57499.sql
ALTER TABLE FEED_STAGING_GOOD_STATICDATA DROP COLUMN longBox;
ALTER TABLE FEED_STAGING_GOOD_STATICDATA DROP COLUMN inventoryDG;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-57499_AddLongBoxAndIDGToStaticDataFeed';

-- 🔁 Rollback for PL/SQL V15.16.0.0.0.8__COL-57531.sql
-- ⚠️ MANUAL CHECK REQUIRED: Cannot restore dropped column or data in ColAgreementHeader
-- EXECUTE IMMEDIATE 'ALTER TABLE ColAgreementHeader DROP COLUMN inventoryDeliveryGroup';
DROP INDEX agreementId_idx;
DROP TABLE ColAgreementInventoryDeliveryGroup;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-57531_Multiple_InventoryDG';

-- 🔁 Rollback for PL/SQL  V15.16.0.0.0.9__COL-57481.sql
ALTER TABLE F3USERPROFILE DROP COLUMN ASSETSERVICEROLE;
DELETE FROM LRSSCHEMAPROPERTIES WHERE moduleName = 'COLLATERAL' AND propertyName = 'COL57481_LONGBOX_AGRMT_SETUP';

-- 🔁 Rollback for PL/SQL V15.16.0.0.0.10__COL-57504.sql
DROP INDEX LONGBOXAGRID_IDX;
ALTER TABLE ColAgreementHeader DROP COLUMN longBoxAgreementId;
ALTER TABLE ColAgreementHeader DROP COLUMN autoUpdatePosition;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-57504_ADD_ASSETSERVICE_CLIENT_TAB';

-- 🔁 Rollback for PL/SQL V15.16.0.0.0.11__COL-57256.sql
ALTER TABLE COLNETTEDSECURITYPARAMOUNT DROP COLUMN imSource;
ALTER TABLE COLNETTEDSECURITYPARAMOUNT DROP COLUMN imSourceAmount;
ALTER TABLE COLNETTEDSECURITYPARAMOUNT DROP COLUMN ownerAgreementAmount;

ALTER TABLE COLSECURITYPARAMOUNT DROP COLUMN imSource;
ALTER TABLE COLSECURITYPARAMOUNT DROP COLUMN imSourceAmount;
ALTER TABLE COLSECURITYPARAMOUNT DROP COLUMN ownerAgreementAmount;

ALTER TABLE COLRPTINASSETHOLDINGS DROP COLUMN imSource;
ALTER TABLE COLRPTINASSETHOLDINGS DROP COLUMN book;
ALTER TABLE COLRPTINASSETHOLDINGS DROP COLUMN inventoryDeliveryGroup;

ALTER TABLE COLRPTOUTASSETHOLDINGS DROP COLUMN imSource;
ALTER TABLE COLRPTOUTASSETHOLDINGS DROP COLUMN book;
ALTER TABLE COLRPTOUTASSETHOLDINGS DROP COLUMN inventoryDeliveryGroup;

DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-57256_AHV_Enhancement_Im_Source';

-- 🔁 Rollback for PL/SQL  V15.16.0.0.0.12__COL-57256.sql
ALTER TABLE COLLETTERDETAILS DROP COLUMN ownerAgreement;
ALTER TABLE COLLETTERDETAILS DROP COLUMN imSource;
ALTER TABLE COLLETTERDETAILS DROP COLUMN imSourceAmount;
ALTER TABLE COLLETTERDETAILS DROP COLUMN ownerAgreementAmount;

ALTER TABLE FEED_STAGING_GOOD_ASSETBOOKING DROP COLUMN imSource;
ALTER TABLE FEED_STAGING_GOOD_ASSETBOOKING DROP COLUMN imSourceAmount;
ALTER TABLE FEED_STAGING_GOOD_ASSETBOOKING DROP COLUMN ownerAgreementAmount;

DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-57429_AHV_Enhancement_Im_Source_S2';

-- 🔁 Rollback for PL/SQL V15.16.0.0.0.13__COL-57603.sql
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN ASSETSERVICEROLE;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN ASSETSERVICECLIENT;
DELETE FROM LRSSCHEMAPROPERTIES WHERE moduleName = 'COLLATERAL' AND propertyName = 'COL57603_LONGBOX_AGR_FEED';

-- 🔁 Rollback for PL/SQL V15.16.0.0.0.14__COL-57608.sql
ALTER TABLE ColRptInAssetHoldings DROP COLUMN assetServiceRole;
ALTER TABLE ColRptOutAssetHoldings DROP COLUMN assetServiceRole;
ALTER TABLE colrptinassetmanagement DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutassetmanagement DROP COLUMN assetServiceRole;
ALTER TABLE colrptinassetsettlement DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutassetsettlement DROP COLUMN assetServiceRole;
ALTER TABLE colrptineligibleasset DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutineligibleasset DROP COLUMN assetServiceRole;
ALTER TABLE colrptinfirmposition DROP COLUMN assetServiceRole;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN assetServiceRole;
ALTER TABLE ColRptInAgreements DROP COLUMN assetServiceRole;
ALTER TABLE COLRPTOUTAGREEMENTS DROP COLUMN assetServiceRole;
ALTER TABLE ColRptInAgreementAudit DROP COLUMN assetServiceRole;
ALTER TABLE ColRptOutAgreementAudit DROP COLUMN assetServiceRole;
ALTER TABLE colrptinsettlementinstruction DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutsettlementinstruction DROP COLUMN assetServiceRole;
ALTER TABLE colrptintrades DROP COLUMN assetServiceRole;
ALTER TABLE colrptouttrades DROP COLUMN assetServiceRole;
ALTER TABLE colrptinrejectedtrades DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutrejectedtrades DROP COLUMN assetServiceRole;
ALTER TABLE colrptinorgagreement DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutorgagreement DROP COLUMN assetServiceRole;
ALTER TABLE colrptinorgthreshold DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutorgthreshold DROP COLUMN assetServiceRole;
ALTER TABLE colrptindailyexposure DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutdailyexposure DROP COLUMN assetServiceRole;
ALTER TABLE colrptinhistoricalexposure DROP COLUMN assetServiceRole;
ALTER TABLE colrptouthistoricalexposure DROP COLUMN assetServiceRole;
ALTER TABLE colrptindisputehistory DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutdisputehistory DROP COLUMN assetServiceRole;
ALTER TABLE colrptininternalreview DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutinternalreview DROP COLUMN assetServiceRole;
ALTER TABLE COLRPTINHISTORICALWORKFLOW DROP COLUMN assetServiceRole;
ALTER TABLE COLRPTOUTHISTORICALWORKFLOW DROP COLUMN assetServiceRole;
ALTER TABLE ColRptInWhatIfScenario DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutwhatifscenario DROP COLUMN assetServiceRole;
ALTER TABLE ColRptInCollateralAvalty DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutcollateralavalty DROP COLUMN assetServiceRole;
ALTER TABLE colrptincorpactions DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutcorpactions DROP COLUMN assetServiceRole;
ALTER TABLE colrptinconclimit DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutconclimit DROP COLUMN assetServiceRole;
ALTER TABLE colrptinclearingtradescom DROP COLUMN assetServiceRole;
ALTER TABLE colrptoutclearingtradescom DROP COLUMN assetServiceRole;

DELETE FROM lrsSchemaProperties WHERE moduleName = 'reports' AND propertyName = 'COL57608_addnewAssetServiceRole';

-- 🔁 Rollback for PL/SQL V15.16.0.0.0.15__COL-57608.sql
ALTER TABLE ColRptOutStatement DROP COLUMN assetServiceRole;
ALTER TABLE ColRptInStatement DROP COLUMN assetServiceRole;

ALTER TABLE COLRPTOUTAGREEMENTS DROP COLUMN assetServiceAgreements;
ALTER TABLE COLRPTOUTAGREEMENTS DROP COLUMN clientAgreements;
ALTER TABLE COLRPTOUTAGREEMENTS DROP COLUMN autoUpdatePosition;

ALTER TABLE ColRptOutAgreementAudit DROP COLUMN assetServiceAgreements;
ALTER TABLE ColRptOutAgreementAudit DROP COLUMN clientAgreements;
ALTER TABLE ColRptOutAgreementAudit DROP COLUMN autoUpdatePosition;

DELETE FROM lrsSchemaProperties WHERE moduleName = 'reports' AND propertyName = 'COL-57608_Add_New_Asset_Service_Role';

