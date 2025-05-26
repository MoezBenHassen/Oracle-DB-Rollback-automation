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
