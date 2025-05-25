DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateral';
    v_property VARCHAR2(100) := 'COL-60285_OPT_Audit_Report';

BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;

INSERT INTO audit_log_mapping (logClassName, logPropertyName, logPropertyDisplayName, isAuditable)
   VALUES ('com.lombardrisk.colline.collateralquery.legacy.ejb3.entity.optimisation.OptRuleTemplateEJB3', 'isLongBox','Long Box',1);

INSERT INTO audit_log_mapping (logClassName, logPropertyName, logPropertyDisplayName, isAuditable)
   VALUES ('com.lombardrisk.colline.collateralquery.legacy.ejb3.entity.optimisation.OptRuleTemplateEJB3', 'isAutobookOnComplete','Auto Book On Complete',1);


INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
