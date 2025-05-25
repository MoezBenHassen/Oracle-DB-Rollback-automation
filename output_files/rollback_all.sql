-- ##############################################  V15.14.0.0 #########################################################################################################
-- 🔁 Rollback for PL/SQL V15.14.0.0.0.0__COL-26734.SQL
-- ⚠️ MANUAL CHECK REQUIRED: ALTER TABLE column modification 
-- EXECUTE IMMEDIATE 'alter table COLRPTOUTASSETSETTLEMENT modify USER_DEFINED_FIELD VARCHAR(1000)';
-- ⚠️ MANUAL CHECK REQUIRED: ALTER TABLE column modification
-- EXECUTE IMMEDIATE 'alter table COLAGREEMENTUSERDEFINEDFIELDS modify UDFVALUE VARCHAR(1000)';
-- Rollback of INSERT INTO lrsschemaproperties
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-26734_updateUdfMaxValue';


-- 🔁 Rollback for PL/SQL V15.14.0.0.0.1__COL-51257.sql
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN referenceRatingAgencies;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN debtClassification;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN selectionOfAgencyDirection;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN selectionOfAgencyUse;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN applicationOfRating;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-51257_S3_Feed_Agreement_Collateral_Tab';


-- 🔁 Rollback for PL/SQL  V15.14.0.0.0.2__COL-51246.sql
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN CallReturn;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN DeliveryRecall;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN InterestPay;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN InterestReceive;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN IMCallReturn;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN IMDeliveryRecall;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN IMInterestPay;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN IMInterestReceive;
-- Rollback of INSERT INTO lrsschemaproperties
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-51246_S4_Feed_Agreement_Settlement_Tab';


-- 🔁 Rollback for PL/SQL V15.14.0.0.0.3__COL-51257.sql
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN assetTypeNames;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN applicableParties;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN applicableTypes;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN agrVsTempEligRules;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN settlementDates;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN deliveryPriorities;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN recallPriorities;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN assetNotes1;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN assetNotes2;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN assetNotes3;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-51257_S3_Feed_Agreement_Collateral_Assets';


-- 🔁 Rollback for PL/SQL V15.14.0.0.0.4__COL-51258.sql
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN SELECTEDPRODUCT;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-51258_S2_Products_tab';


-- 🔁 Rollback for PL/SQL V15.14.0.0.0.5__COL-51352.sql
ALTER TABLE colstatement DROP COLUMN FUTURESETTLEMENTDEBIT;
ALTER TABLE colstatement DROP COLUMN FUTURESETTLEMENTCREDIT;
ALTER TABLE colstatement DROP COLUMN BOOKINGSETTLEMENTTODAY;
ALTER TABLE colstatement DROP COLUMN BOOKINGSETTLEMENTTODAYCASH;
ALTER TABLE colstatement DROP COLUMN BOOKINGSETTLEMENTTODAYNOCASH;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52623_Add3_fields_to_Family_statement';

-- 🔁 Rollback for PL/SQL V15.14.0.0.0.6__COL-51455.sql
DECLARE
    v_sql   CLOB := 'DELETE FROM preferences WHERE ';
    v_vals  CLOB := '7, ''(global)'', ''Stale_Approval_Restriction'', ''false'', NULL';
    i       PLS_INTEGER := 1;
    v_val   VARCHAR2(4000);
    first   BOOLEAN := TRUE;
BEGIN
    FOR col IN (
        SELECT column_name, data_type
        FROM all_tab_columns
        WHERE table_name = UPPER('preferences')
          AND owner = USER
        ORDER BY column_id
    ) LOOP
        EXIT WHEN i > 5;

        v_val := TRIM(REGEXP_SUBSTR(v_vals, '[^,]+', 1, i));

        IF NOT first THEN
            v_sql := v_sql || ' AND ';
        ELSE
            first := FALSE;
        END IF;

        IF col.data_type LIKE '%CHAR%' OR col.data_type = 'CLOB' THEN
            v_sql := v_sql || 'UPPER(' || col.column_name || ') = UPPER(' || v_val || ')';
        ELSE
            v_sql := v_sql || col.column_name || ' = ' || v_val;
        END IF;

        i := i + 1;
    END LOOP;

    EXECUTE IMMEDIATE v_sql;
END;
/
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-51455_Add_field_Stale_Approve_to_Preferences';


-- 🔁 Rollback for PL/SQL V15.14.0.0.0.7__COL-52829.sql
DELETE FROM preferences WHERE PARENT = 7 AND PREFTYPE = '(global)' AND NAME = 'MTA BUSINESS LINES CONFIG' AND PREFVALUE = '41,22';
DELETE FROM lrsSchemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-52829_Adding_and_updating_the_existent_field_on_Configuration>Preferences';

-- 🔁 Rollback for PL/SQL V15.14.0.0.0.8__COL-53238.sql
-- ⚠️ MANUAL CHECK REQUIRED: Cannot automatically revert dropped column
-- EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN SPLITSETTLEMENTPERIOD';
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN SPLITSETTLEMENTPERIOD;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN SETTLEMENTDATEABBRIVIATEDDELIVERIES;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-53238_settlement_date_and_split_settlement_date';


-- 🔁 Rollback for PL/SQL V15.14.0.0.0.9__COL-52618.sql
ALTER TABLE COLBOOKINGRULESTEMP DROP COLUMN NettingIaAndMtm;
ALTER TABLE COLBOOKINGRULESTEMP DROP COLUMN CashflowRules;
ALTER TABLE COLBOOKINGRULESDETAIL DROP COLUMN Value;
ALTER TABLE COLBOOKINGRULESTEMP RENAME COLUMN businessLine TO businessLineV2;
-- ⚠️ MANUAL CHECK REQUIRED: Cannot automatically recreate dropped column
-- EXECUTE IMMEDIATE 'Alter table COLBOOKINGRULESTEMP drop column BusinessLine';
-- ⚠️ MANUAL CHECK REQUIRED: Cannot automatically revert data changes
-- EXECUTE IMMEDIATE 'Update COLBOOKINGRULESTEMP set businessLineV2 = CAST(businessLine AS VARCHAR(255))';
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL52618_S1_Add_Brt_Fields';


-- 🔁 Rollback for PL/SQL V15.14.0.0.0.10__COL-53061.sql 
ALTER TABLE refdata DROP COLUMN substitutionCanceled;
ALTER TABLE colrefdata DROP COLUMN substitutionCanceled;
ALTER TABLE orgrefdata DROP COLUMN substitutionCanceled;
ALTER TABLE UDFValuesRefData DROP COLUMN substitutionCanceled;
ALTER TABLE tradingrefdata DROP COLUMN substitutionCanceled;
DELETE FROM lrsSchemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-53061_cancellation_code';


-- 🔁 Rollback for PL/SQL V15.14.0.0.0.11__COL-52636.sql
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Rejected' AND description = 'Rejected' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Substitution Accepted' AND description = 'Substitution Accepted' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Cancel Initiated' AND description = 'Cancel Initiated' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Cancel Issued' AND description = 'Cancel Issued' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Substitution Cancelled' AND description = 'Substitution Cancelled' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Proposal Initiated' AND description = 'Proposal Initiated' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Proposal Issued' AND description = 'Proposal Issued' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Proposed' AND description = 'Proposed' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Proposal Accepted' AND description = 'Proposal Accepted' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Proposal Rejected' AND description = 'Proposal Rejected' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Proposal Cancelled Initiated' AND description = 'Proposal Cancelled Initiated' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Proposal Cancelled Issued' AND description = 'Proposal Cancelled Issued' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Proposal Cancelled' AND description = 'Proposal Cancelled' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Propose Amended Initiated' AND description = 'Propose Amended Initiated' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Proposal Amended' AND description = 'Proposal Amended' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Replacement Added' AND description = 'Replacement Added' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Replacement Issued' AND description = 'Replacement Issued' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Create Initiated' AND description = 'Create Initiated' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Created Issued' AND description = 'Created Issued' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Amended Initiated' AND description = 'Amended Initiated' AND status = 11;
DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Amended Issued' AND description = 'Amended Issued' AND status = 11;
DELETE FROM RefData WHERE scheme = 'CANCELCODES_AMP' AND refDataValue = '9201' AND description = 'Replacement Collateral Unavailable' AND status = 11 AND flag = 0 AND category = 0 AND substitutionCanceled = 1;
DELETE FROM RefData WHERE scheme = 'CANCELCODES_AMP' AND refDataValue = '9202' AND description = 'Requested Collateral Inaccurate' AND status = 11 AND flag = 0 AND category = 0 AND substitutionCanceled = 1;
DELETE FROM RefData WHERE scheme = 'CANCELCODES_AMP' AND refDataValue = '9203' AND description = 'Asset Recall Not Required' AND status = 11 AND flag = 0 AND category = 0 AND substitutionCanceled = 1;
DELETE FROM RefData WHERE scheme = 'CANCELCODES_AMP' AND refDataValue = '9204' AND description = 'Duplicate Request' AND status = 11 AND flag = 0 AND category = 0 AND substitutionCanceled = 1;
-- ⚠️ MANUAL CHECK REQUIRED: Original values were deleted, cannot be restored automatically
-- DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Substitution Reject Initiated';
-- DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Substitution Accept Initiated';
-- DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Substitution Initiated';
-- DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Substitution Sent';
-- DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Substitution Accept';
-- DELETE FROM RefData WHERE scheme = 'STATUS_AMP' AND refDataValue = 'Substitution Cancel';
DELETE FROM lrsSchemaProperties WHERE moduleName = 'collateral' AND propertyName = 'COL-52636_Update_Substitution_AMP_Statuses';


-- 🔁 Rollback for PL/SQL V15.14.0.0.0.12__COL-52633.sql
ALTER TABLE COLWORKFLOWINTERFACEREF DROP COLUMN CANCELCOMMENT;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52633_Add_comment_field';


-- 🔁 Rollback for PL/SQL V15.14.0.0.0.13__COL-54527.sql
-- ⚠️ MANUAL CHECK REQUIRED: Cannot automatically recreate dropped column
-- EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN SETTLEMENTDATEABBRIVIATEDDELIVERIES';
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN SETTLEMENTDATEABBRIVIATEDDELIVERIES;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-54527_split_settlement_date_fix';


-- 🔁 Rollback for PL/SQL V15.14.0.0.0.14__COL-54855.sql
-- ⚠️ MANUAL CHECK REQUIRED: Cannot automatically revert column size modification
-- EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT MODIFY INTERESTPAY VARCHAR2(50)';
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-54855_fix size INTERESTPAY in FEED_STAGING_GOOD_AGREEMENT';


-- 🔁 Rollback for PL/SQL V15.14.0.0.0.15__COL-55204.sql
ALTER TABLE COLWORKFLOWINTERFACEREF DROP COLUMN COLLINEISSUESUBS;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-55204_Add_collineIssueSubs_field';

-- ##############################################  V15.15.0.0 #########################################################################################################
-- 🔁 Rollback for PL/SQL V15.15.0.0.0.0__COL-56371.sql
ALTER TABLE FEED_STAGING_GOOD_CPAMT DROP COLUMN userAgreedAmount;
ALTER TABLE FEED_STAGING_GOOD_CPAMT DROP COLUMN overwrite;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-56371_Add_fields_in_FEED_STAGING_GOOD_CPAMT';

-- 🔁 Rollback for PL/SQL V15.15.0.0.0.1__COL-55454.sql
ALTER TABLE COLRPTOUTAGREEMENTS DROP COLUMN SPLITSETTLEMENTPERIOD;
-- ⚠️ MANUAL CHECK REQUIRED: Cannot automatically revert column modification
-- EXECUTE IMMEDIATE 'ALTER TABLE COLRPTOUTAGREEMENTS MODIFY ASSETS VARCHAR2(4000)';
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-55454_Add_splitSettPeriod_field';


-- 🔁 Rollback for PL/SQL V15.15.0.0.0.2__COL-56969.sql
DROP SEQUENCE COLINTERESTCOUNTERPARTYDAILYDETAILS_SEQ;
DROP SEQUENCE COLINTERESTCOUNTERPARTYDETAILS_SEQ;
-- ⚠️ MANUAL CHECK REQUIRED: Cannot automatically revert ID updates
-- EXECUTE IMMEDIATE 'UPDATE ColInterestCounterpartyDetails SET ID = ...';
-- EXECUTE IMMEDIATE 'UPDATE ColInterestCounterpartyDailyDetails SET ID = ...';
-- Drop added primary key constraints
ALTER TABLE ColInterestCounterpartyDetails DROP CONSTRAINT pk_ColInterestCounterpartyDetails;
ALTER TABLE ColInterestCounterpartyDailyDetails DROP CONSTRAINT pk_ColInterestCounterpartyDailyDetails;



-- ##############################################  V15.15.2.0 #########################################################################################################
-- 🔁 Rollback for PL/SQL V15.15.2.0.0.1__COL-52255.sql
ALTER TABLE ColAgreementPartyAssets DROP COLUMN prevInternalPolicyPermitsReuse;
ALTER TABLE ColAgreementPartyAssets DROP COLUMN forceChanged;
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52255_Add_fields_in_ColAgreementPartyAssets';

-- 🔁 Rollback for PL/SQL V15.15.2.0.0.2__COL-58813.sql
ALTER TABLE F3JOB DROP COLUMN archiveData;
-- ⚠️ MANUAL CHECK REQUIRED: Cannot revert data updates
-- EXECUTE IMMEDIATE 'update F3JOB set archivedata = 0 where archivedata is null';
DELETE FROM lrsSchemaProperties WHERE moduleName = 'task_scheduler' AND propertyName = 'COL_9999_add_archive_data_column';


-- ##############################################  V15.16.0.0 #########################################################################################################
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

