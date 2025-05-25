DECLARE
results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-67319_fix_Feed_Security';
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

EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_SECURITY ADD corporateactiondate_temp VARCHAR2(255)';
EXECUTE IMMEDIATE 'UPDATE FEED_STAGING_GOOD_SECURITY SET corporateactiondate_temp = TO_CHAR(corporateactiondate, ''YYYY-MM-DD HH24:MI:SS'')';
EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_SECURITY DROP COLUMN corporateactiondate';
EXECUTE IMMEDIATE 'ALTER TABLE FEED_STAGING_GOOD_SECURITY RENAME COLUMN corporateactiondate_temp TO corporateactiondate';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
