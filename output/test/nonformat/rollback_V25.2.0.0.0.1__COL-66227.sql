-- ð Rollback of V25.2.0.0.0.1__COL-66227.sql
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: LASTID NUMBER;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: MAXID NUMBER;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: LASTID := MAXID + 1;
-- â UNHANDLED STATEMENT (please review for manual rollback):
-- ORIGINAL: select count(1)
into results
from lrsschemaproperties l
where l.modulename = 'collateral'
and l.propertyname = 'COL-66227_Include_Interest_On_Coupon_Reinvestment_To_The_MtM_Calc';
-- Revert: DELETE from moeztest using PL/SQL metadata lookup
-- Note: This block assumes values in the INSERT statement do not contain commas themselves.
DECLARE
    v_sql  CLOB := 'DELETE FROM moeztest WHERE ';
    v_vals CLOB := '3, ''SSS'', ''ccc'', ''456 Oak St'', ''tunisia8''';
    i      PLS_INTEGER := 1;
    v_val  VARCHAR2(4000);
    first  BOOLEAN := TRUE;
    v_table_name VARCHAR2(128) := UPPER('moeztest');
BEGIN
    FOR col IN (
        SELECT column_name, data_type
        FROM all_tab_columns
        WHERE table_name = v_table_name
          AND owner = USER -- Consider if schema might be different or passed as parameter
        ORDER BY column_id
    ) LOOP
        -- This simple REGEXP_SUBSTR will break if values themselves contain commas.
        -- For more complex CSV parsing in PL/SQL, a dedicated function would be needed.
        v_val := TRIM(REGEXP_SUBSTR(v_vals, '[^,]+', 1, i));
        EXIT WHEN v_val IS NULL AND i > 1; -- Exit if no more values (allow first value to be NULL)


        IF NOT first THEN
            v_sql := v_sql || ' AND ';
        ELSE
            first := FALSE;
        END IF;

        IF v_val IS NULL OR UPPER(v_val) = 'NULL' THEN
            v_sql := v_sql || col.column_name || ' IS NULL';
        ELSIF col.data_type LIKE '%CHAR%' OR col.data_type = 'CLOB' THEN
            v_sql := v_sql || 'UPPER(' || col.column_name || ') = UPPER(' || v_val || ')';
        ELSIF col.data_type LIKE '%DATE%' OR col.data_type LIKE '%TIMESTAMP%' THEN
             -- For dates/timestamps, v_val must be a string literal that Oracle can implicitly convert,
             -- or a TO_DATE/TO_TIMESTAMP expression. Example: '01-JAN-2024' or TO_DATE('20240101','YYYYMMDD')
             v_sql := v_sql || col.column_name || ' = ' || v_val;
        ELSE -- For numbers predominantly
            v_sql := v_sql || col.column_name || ' = ' || v_val;
        END IF;
        i := i + 1;
    END LOOP;

    IF first THEN -- No conditions were added
        DBMS_OUTPUT.PUT_LINE('-- Rollback for INSERT INTO ' || v_table_name || ': No conditions generated (e.g., no columns found or only NULL values). Manual check required.');
        -- As a precaution, comment out the EXECUTE IMMEDIATE or make it conditional
        -- EXECUTE IMMEDIATE 'SELECT 1 FROM DUAL'; -- No-op or error
    ELSE
        v_sql := v_sql || ';'; -- Add semicolon to complete the SQL
        DBMS_OUTPUT.PUT_LINE('Generated Rollback SQL: ' || v_sql);
        EXECUTE IMMEDIATE v_sql;
        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' row(s) deleted from ' || v_table_name || '.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('-- Error during rollback of INSERT INTO ' || v_table_name || ': ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('-- Attempted SQL: ' || v_sql);
        RAISE; -- Re-raise the exception to ensure failure is noted
END;
/
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-66227_Include_Interest_On_Coupon_Reinvestment_To_The_MtM_Calc';
