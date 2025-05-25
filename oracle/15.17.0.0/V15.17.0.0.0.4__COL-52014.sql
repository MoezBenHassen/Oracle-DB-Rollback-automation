DECLARE
  results    NUMBER;
  v_module   VARCHAR2(100) := 'collateral';
  v_property VARCHAR2(100) := 'COL-52014_ADD_INCLUDEONLYSETTLED_IN_OPTFILTERRULESATTRIBUTE';
  v_counterValue NUMBER;
BEGIN

SELECT count(1)
INTO results
FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0 THEN
    RETURN;
END IF;

FOR rule IN (
    SELECT
      rule.rule_type,
      att.opt_filter_rule_id
    FROM
      opt_filter_rule_attribute att
      INNER JOIN opt_filter_rule rule ON att.opt_filter_rule_id = rule.id
    GROUP BY
      rule.rule_type,
      att.opt_filter_rule_id
    HAVING
      rule.rule_type = 'ASSET'
  ) LOOP

    UPDATE ObjectIdentifier
        SET counterValue = counterValue + 1
        WHERE objectType = 'com.lombardrisk.colline.collateralquery.legacy.ejb3.entity.optimisation.OptFilterRuleAttributeEJB3'
    RETURNING counterValue INTO v_counterValue;


INSERT INTO opt_filter_rule_attribute (
    id,
    opt_filter_rule_id,
    attributekey,
    attributevalue,
    operator,
    andor,
    groupandor,
    sequence,
    groupseq,
    is4im,
    bracketopenlevel,
    bracketclosedlevel,
    bracketandor
)
VALUES (
           v_counterValue,
           rule.opt_filter_rule_id,
           'includeOnlySettled',
           0,
           1,
           0,
           1,
           -6,
           -6,
           0,
           0,
           0,
           0
       );
END LOOP;

INSERT INTO lrsschemaproperties (modulename, propertyname)
VALUES (v_module, v_property);

COMMIT;
END;
/