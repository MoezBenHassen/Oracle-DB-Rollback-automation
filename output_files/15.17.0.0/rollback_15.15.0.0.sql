-- 🔁 Rollback for PL/SQL  V15.17.0.0.0.0__COL-60131.sql
ALTER TABLE ColFirmPosition DROP COLUMN isSettled;
ALTER TABLE FEED_STAGING_GOOD_INVMANAGER DROP COLUMN isSettled;

DELETE FROM lrsschemaproperties 
WHERE modulename = 'collateral' 
  AND propertyname = 'COL-60131_Update_Inventory_Manager_Feed';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.1__COL-52014.sql
ALTER TABLE OPT_RUNRESULT DROP COLUMN bookingApprovalStatus;
ALTER TABLE OPT_RUNRESULT DROP COLUMN latestrun;

DELETE FROM lrsschemaproperties 
WHERE modulename = 'collateral' 
  AND propertyname = 'COL-52014_AddApprovalStatusColumn_To_RunResult';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.2__COL-52014.sql*
ALTER TABLE OPT_RULE_HISTORY_TEMPLATE DROP COLUMN isLongBox;
ALTER TABLE OPT_RULE_TEMPLATE DROP COLUMN isLongBox;

DELETE FROM lrsschemaproperties 
WHERE modulename = 'collateral' 
  AND propertyname = 'COL-52014_AddIsLongBoxColumn_To_RuleTemplate';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.3__COL-52014.sql
DELETE FROM objectIdentifier
WHERE objecttype = 'com.lombardrisk.colline.collateralquery.legacy.ejb3.entity.optimisation.OptFilterRuleAttributeEJB3';

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-52014_ADD_OBJECTIDENTIFIER_FOR_OPTFILTERRULESATTRIBUTE';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.4__COL-52014.sql
-- Delete inserted filter attributes
DELETE FROM opt_filter_rule_attribute
WHERE attributekey = 'includeOnlySettled';
-- ⚠️ MANUAL CHECK REQUIRED: Cannot accurately reverse `counterValue` increment in objectIdentifier
-- Suggest restoring backup or validating expected counterValue manually
DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-52014_ADD_INCLUDEONLYSETTLED_IN_OPTFILTERRULESATTRIBUTE';

-- 🔁 Rollback for PL/SQL  V15.17.0.0.0.5__COL-60456.sql
ALTER TABLE OPT_RULE_HISTORY_TEMPLATE DROP COLUMN nameFormat;
ALTER TABLE OPT_RULE_HISTORY_TEMPLATE DROP COLUMN hasNameFormat;

ALTER TABLE OPT_RULE_TEMPLATE DROP COLUMN nameFormat;
ALTER TABLE OPT_RULE_TEMPLATE DROP COLUMN hasNameFormat;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-60456_AddNameFormat_OPT_Rule';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.6__COL-60285.sql
DELETE FROM audit_log_mapping
WHERE logClassName = 'com.lombardrisk.colline.collateralquery.legacy.ejb3.entity.optimisation.OptRuleTemplateEJB3'
  AND logPropertyName IN ('isLongBox', 'isAutobookOnComplete');

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-60285_OPT_Audit_Report';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.7__COL-60286.sql
-- 🔁 Rollback for COL-60286_OPT_Result_Report

ALTER TABLE ColRptOutOptResult DROP COLUMN approval;
ALTER TABLE ColRptOutOptResult DROP COLUMN originator;
ALTER TABLE ColRptOutOptResult DROP COLUMN nameFormat;

ALTER TABLE OPT_RUNRESULT DROP COLUMN originator;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-60286_OPT_Result_Report';


-- 🔁 Rollback for PL/SQL V15.17.0.0.0.8__COL-60424.sql
-- 🔁 Rollback for COL-60424-AddAuditColumnsFor_OSA_inter_Tables_v2
-- ⚠️ WARNING: This rollback **drops audit columns** and the **auditTrail_view**, and assumes no dependent triggers or data depend on them.
-- ⚠️ Make sure this is not executed on production without proper verification.

-- Drop the view
DROP VIEW auditTrail_view;

-- Drop added columns from each table
ALTER TABLE ColAgreementHeader DROP COLUMN XXX_DAT_CRE;
ALTER TABLE ColAgreementHeader DROP COLUMN XXX_DAT_UPD;

ALTER TABLE F3FREQUENCYDEFINITION DROP COLUMN XXX_DAT_CRE;
ALTER TABLE F3FREQUENCYDEFINITION DROP COLUMN XXX_DAT_UPD;

ALTER TABLE Orgheader DROP COLUMN XXX_DAT_CRE;
ALTER TABLE Orgheader DROP COLUMN XXX_DAT_UPD;

ALTER TABLE ColRefData DROP COLUMN XXX_DAT_CRE;
ALTER TABLE ColRefData DROP COLUMN XXX_DAT_UPD;

ALTER TABLE COLSecurities DROP COLUMN XXX_DAT_CRE;
ALTER TABLE COLSecurities DROP COLUMN XXX_DAT_UPD;

ALTER TABLE colagreementcrossgroup DROP COLUMN XXX_DAT_CRE;
ALTER TABLE colagreementcrossgroup DROP COLUMN XXX_DAT_UPD;

ALTER TABLE colscheduler DROP COLUMN XXX_DAT_CRE;
ALTER TABLE colscheduler DROP COLUMN XXX_DAT_UPD;

ALTER TABLE colagreementlinkage DROP COLUMN XXX_DAT_CRE;
ALTER TABLE colagreementlinkage DROP COLUMN XXX_DAT_UPD;

ALTER TABLE refdata DROP COLUMN XXX_DAT_CRE;
ALTER TABLE refdata DROP COLUMN XXX_DAT_UPD;

ALTER TABLE region DROP COLUMN XXX_DAT_CRE;
ALTER TABLE region DROP COLUMN XXX_DAT_UPD;

ALTER TABLE orgrefdata DROP COLUMN XXX_DAT_CRE;
ALTER TABLE orgrefdata DROP COLUMN XXX_DAT_UPD;

ALTER TABLE colconclimitrule DROP COLUMN XXX_DAT_CRE;
ALTER TABLE colconclimitrule DROP COLUMN XXX_DAT_UPD;

ALTER TABLE colconclimitclassrule DROP COLUMN XXX_DAT_CRE;
ALTER TABLE colconclimitclassrule DROP COLUMN XXX_DAT_UPD;

ALTER TABLE colworkflow DROP COLUMN XXX_DAT_CRE;
ALTER TABLE colworkflow DROP COLUMN XXX_DAT_UPD;

ALTER TABLE colagreementinventorydeliverygroup DROP COLUMN XXX_DAT_CRE;
ALTER TABLE colagreementinventorydeliverygroup DROP COLUMN XXX_DAT_UPD;

ALTER TABLE colfirmposition DROP COLUMN XXX_DAT_CRE;
ALTER TABLE colfirmposition DROP COLUMN XXX_DAT_UPD;

ALTER TABLE colfirmpositionNotional DROP COLUMN XXX_DAT_CRE;
ALTER TABLE colfirmpositionNotional DROP COLUMN XXX_DAT_UPD;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-60424-AddAuditColumnsFor_OSA_inter_Tables_v2';


-- 🔁 Rollback for PL/SQL V15.17.0.0.0.9__COL-60424.sql

DROP INDEX IDX_SEC_dat_upd;

-- Remove property tracking from lrsschemaproperties
DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-60424-AddindexesonAuditColumnsFor_OSA_inter_Tables';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.10__COL-61191.sql
DELETE FROM RefData
WHERE scheme = 'Scheme'
  AND refdatavalue = 'Acadia Interest Benchmark'
  AND description = 'Acadia Interest Benchmark'
  AND status = 11;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-61191_add_benchmark';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.11__COL-60300.sql
DROP INDEX IDX_linkedTicketIdLB;
ALTER TABLE ColSecurityParamount DROP COLUMN linkedTicketIdLB;
ALTER TABLE ColSecurityParamount DROP COLUMN linkedTicketResultLB;
ALTER TABLE ColSecurityParamount DROP COLUMN linkedLongBoxId;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-60300_Add_LB_Bookings_Fields_To_ColSecParamount';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.12__COL-60307.sql

ALTER TABLE COLRPTINASSETHOLDINGS DROP COLUMN linkedTicketIdLB;
ALTER TABLE COLRPTINASSETHOLDINGS DROP COLUMN linkedTicketComment;
ALTER TABLE COLRPTINASSETHOLDINGS DROP COLUMN bookingSource;

ALTER TABLE COLRPTOUTASSETHOLDINGS DROP COLUMN linkedTicketIdLB;
ALTER TABLE COLRPTOUTASSETHOLDINGS DROP COLUMN linkedTicketComment;
ALTER TABLE COLRPTOUTASSETHOLDINGS DROP COLUMN bookingSource;

ALTER TABLE ColRptInAssetSettlement DROP COLUMN linkedTicketComment;
ALTER TABLE ColRptOutAssetSettlement DROP COLUMN linkedTicketComment;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-60307_Add_LB_Bookings_Fields_To_AHV';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.13__COL-60146.sql
DROP TABLE ColInventoryManagerReset;
DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-60146_Add_Inventory_Manager_Reset_Task';


-- 🔁 Rollback for PL/SQL
-- ⚠️ Manual intervention required to restore original INVENTORYDELIVERYGROUP column definitions.
-- Original column types and constraints are unknown. The drop and rename operations must be reversed manually.

-- OPTAGREEMENTPOOL
ALTER TABLE OPTAGREEMENTPOOL DROP COLUMN INVENTORYDELIVERYGROUP; -- Reverts the final VARCHAR2(1024) column
-- ⚠️ MANUAL ACTION REQUIRED: Recreate original INVENTORYDELIVERYGROUP column in OPTAGREEMENTPOOL
-- ❓ Original definition is unknown. Example: ALTER TABLE OPTAGREEMENTPOOL ADD INVENTORYDELIVERYGROUP <DATA_TYPE>;

-- OPTASSETPOOL
ALTER TABLE OPTASSETPOOL DROP COLUMN INVENTORYDELIVERYGROUP;
-- ⚠️ MANUAL ACTION REQUIRED: Recreate original INVENTORYDELIVERYGROUP column in OPTASSETPOOL
-- ❓ Original definition is unknown.

-- OPTSOURCEDETAILS
ALTER TABLE OPTSOURCEDETAILS DROP COLUMN INVENTORYDELIVERYGROUP;
-- ⚠️ MANUAL ACTION REQUIRED: Recreate original INVENTORYDELIVERYGROUP column in OPTSOURCEDETAILS
-- ❓ Original definition is unknown.

-- ⚠️ MANUAL ACTION REQUIRED: 
-- UPDATE OPTAGREEMENTPOOL SET INVENTORYDELIVERYGROUP_NEW = INVENTORYDELIVERYGROUP;
-- UPDATE OPTASSETPOOL SET INVENTORYDELIVERYGROUP_NEW = INVENTORYDELIVERYGROUP;
-- UPDATE OPTSOURCEDETAILS SET INVENTORYDELIVERYGROUP_NEW = INVENTORYDELIVERYGROUP;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-52014_UPDATE_IDG_TYPE_IN_OPTIMISER_TABLES';


-- 🔁 Rollback for PL/SQL V15.17.0.0.0.15__COL-52014.sql
ALTER TABLE OPTASSETPOOL DROP COLUMN ASSETSERVICEROLE;
ALTER TABLE OPTSOURCEDETAILS DROP COLUMN ASSETSERVICEROLE;
DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-52014_ADD_ASSETSERVICEROLE_TO_ASSETPOOL';


-- 🔁 Rollback for PL/SQL V15.17.0.0.0.16__COL-52014.sql
ALTER TABLE OPTAGREEMENTPOOL DROP COLUMN longboxAgreementId;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-52014_ADD_LINKEDLBID_TO_AGREEMENTPOOL';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.17__COL-60149.sql
ALTER TABLE ColRptOutFirmPosition DROP COLUMN confirmedNotionalT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN confirmedNativeValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN confirmedReUseT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN confirmedReportingValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN confirmedPositionT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN EODConfirmedNotionalT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN EODConfirmedReUseT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN EODConfirmedNativeValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN EODConfirmedReportingValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN EODExpectedNotionalT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN EODExpectedReUseT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN EODExpectedNativeValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN EODExpectedReportingValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN SODConfirmedNotionalT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN SODConfirmedReUseT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN SODConfirmedNativeValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN SODConfirmedReportingValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN SODExpectedNotionalT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN SODExpectedNativeValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN SODExpectedReUseT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN SODExpectedReportingValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN intraDayConfirmedNotionalT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN intraDayConfirmedReUseT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN intraDayConfirmedNativeValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN intraDayConfirmedReportingValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN intraDayExpectedNotionalT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN intraDayExpectedReUseT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN intraDayExpectedNativeValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN intraDayExpectedReportingValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN pendingNotionalT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN pendingNativeValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN pendingReUseT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN pendingReportingValueT;
ALTER TABLE ColRptOutFirmPosition DROP COLUMN isSettled;

DELETE FROM lrsschemaproperties
WHERE modulename = 'reports'
  AND propertyname = 'COL-60149_Inventory_Manager_Report';


-- 🔁 Rollback for PL/SQL V15.17.0.0.0.18__COL-52014.sql
ALTER TABLE OPTAGREEMENTPOOL DROP COLUMN ASSETSERVICEROLE;
DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-52014_ADD_ASSETSERVICEROLE_TO_AGRPOOL';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.19__COL-62691.sql
DROP TRIGGER colfirmposition_trig_del;

DROP INDEX IDX_FIRMPOSITION_DEL_DATE;
DROP INDEX IDX_FIRMPOSITION_DEL_ID;

DROP TABLE colfirmpositionDelete;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-62691-AddtriggerForColfirmpositionWhenDelete';


-- 🔁 Rollback for PL/SQL V15.17.0.0.0.20__COL-62691.sql
-- to be continued
-- 🔁 Rollback for PL/SQL
-- 🔁 Rollback for PL/SQL
-- 🔁 Rollback for PL/SQL
-- 🔁 Rollback for PL/SQL
-- 🔁 Rollback for PL/SQL
-- 🔁 Rollback for PL/SQL
-- 🔁 Rollback for PL/SQL
-- 🔁 Rollback for PL/SQL
-- 🔁 Rollback for PL/SQL
-- 🔁 Rollback for PL/SQL
-- 🔁 Rollback for PL/SQL
-- 🔁 Rollback for PL/SQL
-- 🔁 Rollback for PL/SQL
-- 🔁 Rollback for PL/SQL
