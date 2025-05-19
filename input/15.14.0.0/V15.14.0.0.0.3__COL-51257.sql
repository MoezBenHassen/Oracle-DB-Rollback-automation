DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-51257_S3_Feed_Agreement_Collateral_Assets';
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

EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT ADD assetTypeNames CLOB';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT ADD applicableParties CLOB';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT ADD applicableTypes CLOB';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT ADD agrVsTempEligRules CLOB';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT ADD settlementDates CLOB';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT ADD deliveryPriorities CLOB';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT ADD recallPriorities CLOB';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT ADD assetNotes1 CLOB';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT ADD assetNotes2 CLOB';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT ADD assetNotes3 CLOB';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;