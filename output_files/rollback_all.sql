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


-- ##############################################  V15.16.1.0 #########################################################################################################
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


-- ##############################################  V15.16.2.0 #########################################################################################################
-- 🔁 Rollback for PL/SQL V15.16.2.0.0.0__COL-60292.sql
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN bufferSection;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN principalBufferTypes;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN principalBufferLowerLimits;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN principalBufferUpperLimits;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN principalBufferTargets;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN principalBufferCcy;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN cptyBufferTypes;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN cptyBufferLowerLimits;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN cptyBufferUpperLimits;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN cptyBufferTargets;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN cptyBufferCcy;

ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN imBufferSection;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN imPrincipalBufferTypes;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN imPrincipalBufferLowerLimits;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN imPrincipalBufferUpperLimits;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN imPrincipalBufferTargets;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN imPrincipalBufferCcy;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN imCptyBufferTypes;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN imCptyBufferLowerLimits;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN imCptyBufferUpperLimits;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN imCptyBufferTargets;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN imCptyBufferCcy;

DELETE FROM LRSSCHEMAPROPERTIES WHERE moduleName = 'COLLATERAL' AND propertyName = 'COL_60292_Issue_with_uploading_of_CCP_agreements_template_feed';

-- 🔁 Rollback for PL/SQL V15.16.2.0.0.1__COL-60429.sql
DELETE FROM COL_PURGE_TABLES 
WHERE TABLE_NAME = 'ColStatementBufferHistory' 
  AND COLUMN_DEL = 'statementHistoryId' 
  AND DOMAIN = 'StatementHistory';

DELETE FROM lrsSchemaProperties 
WHERE moduleName = 'collateral' 
  AND propertyName = 'COL60429_Purge_Archived_Statements_task';

-- 🔁 Rollback for PL/SQL V15.16.2.0.0.2__COL-60491.sql
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN prinSWIFTMessaging;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN cptySWIFTMessaging;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN prinIMSWIFTMessaging;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN cptyIMSWIFTMessaging;

DELETE FROM LRSSCHEMAPROPERTIES 
WHERE moduleName = 'COLLATERAL' 
  AND propertyName = 'COL_60491_Agreement_feed_Excel_feed_success_with_warning_message_related_to_SWIFTMessaging';

-- 🔁 Rollback for PL/SQL V15.16.2.0.0.3__COL-60495.sql
ALTER TABLE ColStatement ADD vmLowerLimitPrinc FLOAT(126);
ALTER TABLE ColStatement ADD imLowerLimitPrinc FLOAT(126);
ALTER TABLE ColStatement ADD vmLowerLimitCpty FLOAT(126);
ALTER TABLE ColStatement ADD imLowerLimitCpty FLOAT(126);
ALTER TABLE ColStatement ADD vmUpperLimitPrinc FLOAT(126);
ALTER TABLE ColStatement ADD imUpperLimitPrinc FLOAT(126);
ALTER TABLE ColStatement ADD vmUpperLimitCpty FLOAT(126);
ALTER TABLE ColStatement ADD imUpperLimitCpty FLOAT(126);

ALTER TABLE ColStatementHistory ADD vmLowerLimitPrinc FLOAT(126);
ALTER TABLE ColStatementHistory ADD imLowerLimitPrinc FLOAT(126);
ALTER TABLE ColStatementHistory ADD vmLowerLimitCpty FLOAT(126);
ALTER TABLE ColStatementHistory ADD imLowerLimitCpty FLOAT(126);
ALTER TABLE ColStatementHistory ADD vmUpperLimitPrinc FLOAT(126);
ALTER TABLE ColStatementHistory ADD imUpperLimitPrinc FLOAT(126);
ALTER TABLE ColStatementHistory ADD vmUpperLimitCpty FLOAT(126);
ALTER TABLE ColStatementHistory ADD imUpperLimitCpty FLOAT(126);

ALTER TABLE ColStatementBufferHistory DROP COLUMN vmBufferTypePrinc;
ALTER TABLE ColStatementBufferHistory DROP COLUMN vmBufferTypeCpty;
ALTER TABLE ColStatementBufferHistory DROP COLUMN imbufferTypePrinc;
ALTER TABLE ColStatementBufferHistory DROP COLUMN imbufferTypeCpty;

ALTER TABLE ColStatementHistory DROP COLUMN adjVmMarginReqPrinc;
ALTER TABLE ColStatementHistory DROP COLUMN adjVmMarginReqCtpy;
ALTER TABLE ColStatementHistory DROP COLUMN adjIaMarginReqPrinc;
ALTER TABLE ColStatementHistory DROP COLUMN adjIaMarginReqCtpy;
ALTER TABLE ColStatementHistory DROP COLUMN adjVMNetED;
ALTER TABLE ColStatementHistory DROP COLUMN adjIMNetED;

DELETE FROM lrsschemaProperties 
WHERE moduleName = 'collateral' 
  AND propertyName = 'COL-60495_update_statement_archive';


-- 🔁 Rollback for PL/SQL V15.16.2.0.0.4__COL-61422.sql
-- ⚠️ MANUAL CHECK REQUIRED:
-- Cannot restore original datatype of `cleanPrice` column because its prior type is unknown (e.g., NUMBER, FLOAT, etc.).
-- Additionally, the `cleanPrice` column was dropped and recreated, so data may be lost or altered.
-- Manual restoration needed if data type restoration or data integrity is required.
DELETE FROM lrsschemaproperties 
WHERE moduleName = 'collateral' 
  AND propertyName = 'COL-61422_RepoETFSBL_Rejected_Trades_Report_task_failed_to_run_[Postgres]';


-- 🔁 Rollback for PL/SQL V15.16.2.0.0.5__COL-61423.sql
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT ADD bufferSection_tmp NUMBER(1);
UPDATE FEED_STAGING_GOOD_AGREEMENT
   SET bufferSection_tmp = CASE 
                             WHEN bufferSection = 'true' THEN 1 
                             WHEN bufferSection = 'false' THEN 0 
                             ELSE NULL 
                           END;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN bufferSection;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT RENAME COLUMN bufferSection_tmp TO bufferSection;

ALTER TABLE FEED_STAGING_GOOD_AGREEMENT ADD imBufferSection_tmp NUMBER(1);
UPDATE FEED_STAGING_GOOD_AGREEMENT
   SET imBufferSection_tmp = CASE 
                               WHEN imBufferSection = 'true' THEN 1 
                               WHEN imBufferSection = 'false' THEN 0 
                               ELSE NULL 
                             END;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT DROP COLUMN imBufferSection;
ALTER TABLE FEED_STAGING_GOOD_AGREEMENT RENAME COLUMN imBufferSection_tmp TO imBufferSection;

DELETE FROM LRSSCHEMAPROPERTIES 
WHERE moduleName = 'COLLATERAL' 
  AND propertyName = 'COL_61423_Colline_Unable_to_Consume_Invalid_Value_for_Buffer_Section';

-- ##############################################  V15.16.3.0 #########################################################################################################
-- 🔁 Rollback for PL/SQL V15.16.3.0.0.0__COL-61927.sql
ALTER TABLE COLRPTOUTAGREEMENTS DROP COLUMN prinTargetBuffer;
ALTER TABLE COLRPTOUTAGREEMENTS DROP COLUMN cptytargetbuffer;
ALTER TABLE COLRPTOUTAGREEMENTS DROP COLUMN imPrinTargetBuffer;
ALTER TABLE COLRPTOUTAGREEMENTS DROP COLUMN imcptyTargetBuffer;

DELETE FROM LRSSCHEMAPROPERTIES 
WHERE MODULENAME = 'collateralReports' 
  AND PROPERTYNAME = 'COL-61927_Colline_crashes_when_saving_agreement_report';



-- ##############################################  V15.17.0.0 #########################################################################################################
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
-- Rollback for COL-62691-AddindexesonAuditColumnsFor_OSA_inter_Tables

-- Check if manually dropped index needs to be recreated
-- CREATE INDEX IDX_SEC_dat_upd ON colsecurities(xxx_dat_upd); -- MANUAL CHECK REQUIRED

-- Drop created indexes
DROP INDEX idx_COLAGREEMENTHEADER_dat_upd;
DROP INDEX idx_F3FREQUENCYDEFINITION_dat_upd;
DROP INDEX idx_ORGHEADER_dat_upd;
DROP INDEX idx_COLREFDATA_dat_upd;
DROP INDEX idx_COLSECURITIES_dat_upd;
DROP INDEX idx_COLAGREEMENTCROSSGROUP_dat_upd;
DROP INDEX idx_COLSCHEDULER_dat_upd;
DROP INDEX idx_COLAGREEMENTLINKAGE_dat_upd;
DROP INDEX idx_REFDATA_dat_upd;
DROP INDEX idx_REGION_dat_upd;
DROP INDEX idx_ORGREFDATA_dat_upd;
DROP INDEX idx_COLCONCLIMITRULE_dat_upd;
DROP INDEX idx_COLCONCLIMITCLASSRULE_dat_upd;
DROP INDEX idx_COLWORKFLOW_dat_upd;
DROP INDEX idx_COLAGREEMENTINVENTORYDELIVERYGROUP_dat_upd;
DROP INDEX idx_COLFIRMPOSITION_dat_upd;
DROP INDEX idx_COLFIRMPOSITIONNOTIONAL_dat_upd;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-62691-AddindexesonAuditColumnsFor_OSA_inter_Tables';


-- 🔁 Rollback for PL/SQL V15.17.0.0.0.21__COL-62691.sql
DROP TABLE colfirmpositionNotionalDelete;

DROP INDEX IDX_Frm_NOTION_DEL_ID;
DROP INDEX IDX_Frm_NOTION_DEL_DATE;
DROP INDEX idx_colfirmpositionNotional_dat_upd;

DROP TRIGGER colfirmpositionNotional_trig_del;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-62691-AddtriggerForColfirmpositionNotionalWhenDelete';


-- 🔁 Rollback for PL/SQL V15.17.0.0.0.22__COL-62395.sql
ALTER TABLE COLINVENTORYMANAGERRESET DROP COLUMN FEEDDATE;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-62395_UPDATE_INVENTORY_MANAGER_RESET_WITH_FEEDDATE';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.23__COL-60311.sql
ALTER TABLE colrefdata DROP COLUMN match;
ALTER TABLE orgrefdata DROP COLUMN match;
ALTER TABLE refdata DROP COLUMN match;
ALTER TABLE udfvaluesrefdata DROP COLUMN match;
ALTER TABLE TRADINGREFDATA DROP COLUMN match;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-60311_idg_match';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.24__COL-56605.sql
DELETE FROM roleprivileges
WHERE privilege = 'collateral.tag.exceed.amount'
  AND rolename = 'admin'
  AND description = 'Auto Tagging';

DELETE FROM lrsschemaproperties
WHERE modulename = 'Collateral'
  AND propertyname = 'COL-56605_Add_Auto_Tag_Privilege';


-- 🔁 Rollback for PL/SQL V15.17.0.0.0.25__COL-56606.sql
ALTER TABLE COLSECURITYPARAMOUNT DROP COLUMN maxRecallByTag;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-56606_Auto_tagging_logic';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.26__COL-56607.sql
ALTER TABLE ColAgreementInstrument DROP COLUMN maxReuseAvailable;
ALTER TABLE ColAgreementInstrument DROP COLUMN maxReuseHolding;

DELETE FROM lrsschemaproperties
WHERE modulename = 'COLLATERAL'
  AND propertyname = 'COL-56607_ReuseAvailable_ReuseHolding';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.27__COL-56608.sql 
DROP INDEX TAGGED_DELIVERY_PARAMOUNT_COLSECURITYPARAMOUNT;
DROP INDEX TAGGED_DELIVERY_PARAMOUNT_COLSECURITYINFO;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-56608_Inventory_Source_available';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.28__COL-61058.sql
ALTER TABLE colrptoutassetsettlement DROP COLUMN ownerAgreementAmount;
ALTER TABLE colrptoutassetsettlement DROP COLUMN inventorySource;
ALTER TABLE colrptoutassetsettlement DROP COLUMN inventorySourceAmount;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-60158_Asset_Settlement_Report_S6';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.29__COL-62700.sql
ALTER TABLE COLFIRMPOSITION DROP COLUMN ISDELTAFEED;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-62700_ADD_ISDELTAFEED_TO_COLFIRMPOSITION';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.30__COL-56609.sql
ALTER TABLE ColSecurityParamount DROP COLUMN rehypoFrom;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL_56609_rehypo_from_ColSecurityParamount';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.31__COL-62872.sql
ALTER TABLE COLFIRMPOSITION DROP COLUMN FEEDTIME;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-62872_UPDATE_COLFIRMPOSITION_WITH_FEEDTIME';

-- 🔁 Rollback for PL/SQL V15.17.0.0.0.32__COL-63186.sql
DROP VIEW auditTrail_view;

ALTER TABLE colagreementassets DROP COLUMN XXX_DAT_CRE;
ALTER TABLE colagreementassets DROP COLUMN XXX_DAT_UPD;

ALTER TABLE colassets DROP COLUMN XXX_DAT_CRE;
ALTER TABLE colassets DROP COLUMN XXX_DAT_UPD;

DELETE FROM lrsschemaproperties
WHERE modulename = 'collateral'
  AND propertyname = 'COL-63186-AddAuditColumnsFor_OSA_inter_Tables_v3';


-- ##############################################  V15.17.1.0 #########################################################################################################
-- ##############################################  V25.1.0.0 #########################################################################################################
-- ##############################################  V25.2.0.0 #########################################################################################################