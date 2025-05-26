-- 🔁 Rollback for PL/SQL  V15.16.1.0.0.0__COL-57222.sql
DELETE FROM ColRefData WHERE SCHEME = 'Scheme' AND REFDATAVALUE = 'Third Party Approval' AND DESCRIPTION = 'Depot Bank' AND STATUS = 11 AND CATEGORY = 0 AND FLAG = 0 AND SWIFTREFID = 0;
DELETE FROM lrsSchemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL57222_Third_Party_Approval';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.1__COL-57223.sql
ALTER TABLE F3UserProfile DROP COLUMN thirdPartyApproval;
DELETE FROM lrsschemaProperties WHERE moduleName = 'f3' AND propertyName = 'COL-57223_thirdPartyApproval_S2_User_Profile';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.2__COL-57234.sql
ALTER TABLE ColScheduler DROP COLUMN ThirdPartyApproval;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL57234_third_party';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.3__COL-57235.sql
ALTER TABLE COLRPTOUTAGREEMENTS DROP COLUMN THIRDPARTYAPPROVAL;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-57235_Add_thirdPartyApproval';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.4__COL-57235.sql
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN THIRDPARTYAPPROVALTYPE;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN THIRDPARTYAPPROVAL;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-57235_Feed_Extract_impacts';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.5__COL-57246.sql
ALTER TABLE COLRPTOUTASSETHOLDINGS DROP COLUMN REJECTED;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateralreports' AND propertyName = 'COL57246_addcolumnstoColRptOutAssetHoldings';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.6__COL-59354
ALTER TABLE ColRptInAssetSettlement DROP COLUMN ONLYREJECTED;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateralreports' AND propertyName = 'COL59354_addOnlyRejectedColumnIntoColRptInAssetSettlement';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.7__COL-58220.sql
DROP INDEX ColBufferItemIndex;
DROP SEQUENCE COLBUFFERITEM_SEQ;
DROP TABLE ColBufferItem;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-58220_BUFFER_S1';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.8__COL-58223.sql
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN Bffr;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN IMBffr;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-58223_S2.3_Agreement_Feed';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.9__COL-58225.sql
DROP SEQUENCE ColStatementBuffer_SEQ;
DROP TABLE ColStatementBuffer;

DROP SEQUENCE ColStatementBufferHistory_SEQ;
DROP TABLE ColStatementBufferHistory;

DROP SEQUENCE ColStatementModelBuffer_SEQ;
DROP TABLE ColStatementModelBuffer;

DROP SEQUENCE ColStatementModelBufferHistory_SEQ;
DROP TABLE ColStatementModelBufferHistory;

ALTER TABLE ColStatement DROP COLUMN adjVmMarginReqPrinc;
ALTER TABLE ColStatement DROP COLUMN adjVmMarginReqCtpy;
ALTER TABLE ColStatement DROP COLUMN adjIaMarginReqPrinc;
ALTER TABLE ColStatement DROP COLUMN adjIaMarginReqCtpy;
ALTER TABLE ColStatement DROP COLUMN adjVMNetED;
ALTER TABLE ColStatement DROP COLUMN adjIMNetED;

DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-58225_Add_Buffer_Tables_Update_Statement';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.10__COL-58231.sql
ALTER TABLE ColStatement DROP COLUMN appliedTargetBuffer;
ALTER TABLE ColStatement DROP COLUMN imAppliedTargetBuffer;

ALTER TABLE ColStatementBuffer DROP COLUMN netEdOrMarginReqAppliedPrinc;
ALTER TABLE ColStatementBuffer DROP COLUMN netEdOrMarginReqAppliedCpty;
ALTER TABLE ColStatementBuffer DROP COLUMN imNetEdOrMarginReqAppliedPrinc;
ALTER TABLE ColStatementBuffer DROP COLUMN imNetEdOrMarginReqAppliedCpty;

ALTER TABLE ColStatementBuffer DROP COLUMN vmBufferTypePrinc;
ALTER TABLE ColStatementBuffer DROP COLUMN vmBufferTypeCpty;
ALTER TABLE ColStatementBuffer DROP COLUMN imbufferTypePrinc;
ALTER TABLE ColStatementBuffer DROP COLUMN imbufferTypeCpty;

DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-58231_Logic_for_Calculating_Margin_events_with_Dual_Buffer_Types';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.11__COL-60013.sql
ALTER TABLE COLRPTINETDAGING DROP COLUMN taskType;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateralreports' AND propertyName = 'COL-60013-Collines-crashed-when-i-click-on-save-template';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.12__COL-59381.sql
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN assetServiceLinkedAgrExtIds;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN clientLinkedAgrExtIds;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN autoUpdatePosition;
DELETE FROM LRSSCHEMAPROPERTIES WHERE moduleName = 'COLLATERAL' AND propertyName = 'COL_59381_LONGBOX_AGR_FEED';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.13__COL-57613.sql
ALTER TABLE F3JOB DROP COLUMN ASSETSERVICEROLE;
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-57613';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.14__COL-60049.sql
ALTER TABLE ColRptInAssetHoldings DROP COLUMN rejected;
-- ⚠️ MANUAL CHECK REQUIRED: Original column "rejected" in colrptoutassetholdings was dropped and cannot be automatically restored
-- ALTER TABLE colrptoutassetholdings ADD rejected VARCHAR2(50);
DELETE FROM lrsschemaProperties WHERE moduleName = 'collateralreports' AND propertyName = 'COL-60049_Cannot_create_select_Report_Template_under_Asset_Holdings_Valuation_Report';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.15__COL-56689.sql
ALTER TABLE ColRptOutSecurity DROP COLUMN udf31;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf32;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf33;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf34;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf35;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf36;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf37;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf38;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf39;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf40;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf41;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf42;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf43;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf44;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf45;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf46;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf47;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf48;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf49;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf50;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf51;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf52;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf53;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf54;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf55;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf56;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf57;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf58;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf59;
ALTER TABLE ColRptOutSecurity DROP COLUMN udf60;

DELETE FROM lrsschemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-56689_Add_additional_Security_UDF';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.16__COL-59470.sql
DELETE FROM f3job 
WHERE jobname = 'Approve Settlement Instructions' 
  AND groupname = 'Workflow' 
  AND jobclassname = 'com.lombardrisk.colline.asset.service.impl.job.ColApproveSettlementInstructionsJob';

DELETE FROM lrsSchemaProperties 
WHERE moduleName = 'collateral' 
  AND propertyName = 'COL59470_Approve_Settlement_Instructions_Task';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.17__ COL-58227.sql
ALTER TABLE ColStatementBuffer DROP CONSTRAINT fk_statement;
ALTER TABLE ColStatementBuffer DROP COLUMN statementmodelId;

ALTER TABLE ColStatementModel DROP COLUMN adjVmMarginReqPrinc;
ALTER TABLE ColStatementModel DROP COLUMN adjVmMarginReqCtpy;
ALTER TABLE ColStatementModel DROP COLUMN adjIaMarginReqPrinc;
ALTER TABLE ColStatementModel DROP COLUMN adjIaMarginReqCtpy;
ALTER TABLE ColStatementModel DROP COLUMN adjVMNetED;
ALTER TABLE ColStatementModel DROP COLUMN adjIMNetED;

DELETE FROM lrsSchemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-58227_Add_Buffer_Fields_Multimodel';

-- 🔁 Rollback for PL/SQL V15.16.1.0.0.18__COL-60229.sql
-- ⚠️ MANUAL CHECK REQUIRED: Original constraint name and behavior are unknown.
-- Cannot restore original constraint without its exact definition.

ALTER TABLE ColBufferItem DROP CONSTRAINT fk_colbufferitem_colrating;

DELETE FROM lrsSchemaProperties 
WHERE moduleName = 'collateral' 
  AND propertyName = 'COL-60229_Colline_Crashes_when_update_Not_Net';
