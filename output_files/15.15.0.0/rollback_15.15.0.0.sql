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
