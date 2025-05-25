-- ##############################################  V15.14.0.0 ##############################################
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

-- ##############################################  V15.15.0.0 ##############################################