DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-51246_S4_Feed_Agreement_Settlement_Tab';
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

EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT add CallReturn varchar2(50)';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT add DeliveryRecall varchar2(50)';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT add InterestPay varchar2(10)';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT add InterestReceive varchar2(50)';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT add IMCallReturn varchar2(50)';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT add IMDeliveryRecall varchar2(50)';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT add IMInterestPay varchar2(50)';
EXECUTE IMMEDIATE 'Alter table FEED_STAGING_GOOD_AGREEMENT add IMInterestReceive varchar2(50)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;