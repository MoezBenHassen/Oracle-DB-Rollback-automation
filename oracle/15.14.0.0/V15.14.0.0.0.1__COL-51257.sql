DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-51257_S3_Feed_Agreement_Collateral_Tab';
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

EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT add referenceRatingAgencies varchar2(100)';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT add debtClassification varchar2(50)';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT add selectionOfAgencyDirection varchar2(50)';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT add selectionOfAgencyUse varchar2(50)';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT add applicationOfRating varchar2(50)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;