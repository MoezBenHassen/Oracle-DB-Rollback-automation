--START
DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-52014_ADD_OBJECTIDENTIFIER_FOR_OPTFILTERRULESATTRIBUTE';
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

    INSERT
    INTO objectIdentifier
      (SELECT 'com.lombardrisk.colline.collateralquery.legacy.ejb3.entity.optimisation.OptFilterRuleAttributeEJB3' AS OBJECTTYPE,
          (SELECT
            CASE
              WHEN MAX(id) IS NULL
              THEN 1
              ELSE MAX(id) + 500
            END
          FROM OPT_FILTER_RULE_ATTRIBUTE
          ) AS countervalue
        FROM dual
      );


INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
--END