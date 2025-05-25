DECLARE
results    NUMBER;
    v_module   VARCHAR2(100) := 'collateralreports';
    v_property VARCHAR2(100) := 'COL-60013-Collines-crashed-when-i-click-on-save-template';
    v_column_exists integer;
BEGIN

SELECT count(1) INTO results FROM lrsschemaproperties l
WHERE l.modulename = v_module
  AND l.propertyname = v_property;

IF results > 0
    THEN
        RETURN;
END IF;
		  SELECT COUNT(*) INTO v_column_exists
            FROM
                user_tab_cols
            WHERE
                upper(column_name) = 'TASKTYPE'
                AND table_name = 'COLRPTINETDAGING';

            IF ( v_column_exists = 0 ) THEN
                EXECUTE IMMEDIATE 'ALTER TABLE COLRPTINETDAGING ADD taskType VARCHAR2(250)';
            END IF;


INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);
COMMIT;
END;
/
