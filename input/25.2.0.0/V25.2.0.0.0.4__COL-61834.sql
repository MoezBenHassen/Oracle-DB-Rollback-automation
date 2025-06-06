DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-61834_Agreement_Feed_IA';
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

EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT ADD agreementIA CLOB';

EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT ADD independentAmount VARCHAR2(255)';
EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT ADD upfrontCalculMethodology VARCHAR2(255)';
EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT ADD principleUpfronts VARCHAR2(255)';
EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT ADD fixedValue VARCHAR2(255)';
EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_AGREEMENT ADD fixedPerc VARCHAR2(255)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;