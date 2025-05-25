DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
v_property VARCHAR2(100) := 'COL-57499_AddLongBoxAndIDGToStaticDataFeed';
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


EXECUTE IMMEDIATE 'alter table FEED_STAGING_GOOD_STATICDATA add (longBox VARCHAR2(5) DEFAULT null ,inventoryDG VARCHAR2(100) DEFAULT null)';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
