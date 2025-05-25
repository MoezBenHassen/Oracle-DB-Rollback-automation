DECLARE
    results      NUMBER;
    colcount     NUMBER;
    v_module     VARCHAR2(100) := 'collateralreports';
    v_property   VARCHAR2(100) := 'COL57246_addcolumnstoColRptOutAssetHoldings';
BEGIN
    SELECT
        COUNT(1)
    INTO results
    FROM
        lrsschemaproperties l
    WHERE
        l.modulename = v_module
        AND l.propertyname = v_property;

    IF results > 0 THEN
        return;
    END IF;

    -- Check if ORIGINALNOMINAL column exists and add it if it doesn't
    SELECT
        COUNT(*)
    INTO colcount
    FROM
        user_tab_cols
    WHERE
        table_name = 'COLRPTOUTASSETHOLDINGS'
        AND column_name = 'REJECTED';

    IF colcount = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE COLRPTOUTASSETHOLDINGS ADD REJECTED VARCHAR2(50) default 0';
    END IF;

    INSERT INTO lrsschemaproperties (modulename, propertyname) VALUES (v_module, v_property);

    COMMIT;
END;