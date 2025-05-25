DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-64639_UPDATE_INVENTORY_MANAGER_RESET_WITH_IS_DELTA_FEED';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

EXECUTE IMMEDIATE 'ALTER TABLE COLINVENTORYMANAGERRESET ADD isDeltaFeed NUMBER(1,0) DEFAULT 0';

INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
