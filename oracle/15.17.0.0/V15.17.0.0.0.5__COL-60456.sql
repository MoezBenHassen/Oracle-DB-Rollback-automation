DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-60456_AddNameFormat_OPT_Rule';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'ALTER TABLE OPT_RULE_HISTORY_TEMPLATE add hasNameFormat  number(1) DEFAULT 0 ';
EXECUTE IMMEDIATE 'ALTER TABLE OPT_RULE_HISTORY_TEMPLATE add nameFormat  varchar2(1024) ';

EXECUTE IMMEDIATE 'ALTER TABLE OPT_RULE_TEMPLATE add hasNameFormat  number(1) DEFAULT 0 ';
EXECUTE IMMEDIATE 'ALTER TABLE OPT_RULE_TEMPLATE add nameFormat  varchar2(1024) ';


INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
