-- 🔁 Rollback of V15.14.0.0.0.6__COL-51455.sql
-- ⚠️ MANUAL CHECK REQUIRED: CASE NOT HANDLED
-- ORIGINAL: INSERT into preferences VALUES (LASTID , 7, '(global)', 'Stale_Approval_Restriction', 'false', null);
-- Revert: DELETE from moeztest using PL/SQL metadata lookup
DECLARE
    v_sql   CLOB := 'DELETE FROM moeztest WHERE ';
    v_vals  CLOB := '3, ''SSS'', ''ccc'', ''456 Oak St'', ''tunisia8''';
    i       PLS_INTEGER := 1;
    v_val   VARCHAR2(4000);
    first   BOOLEAN := TRUE;
BEGIN
    FOR col IN (
        SELECT column_name, data_type
        FROM all_tab_columns
        WHERE table_name = UPPER('moeztest')
          AND owner = USER
        ORDER BY column_id
    ) LOOP
        v_val := TRIM(REGEXP_SUBSTR(v_vals, '[^,]+', 1, i));
        EXIT WHEN v_val IS NULL;

        IF NOT first THEN
            v_sql := v_sql || ' AND ';
        ELSE
            first := FALSE;
        END IF;

        IF col.data_type LIKE '%CHAR%' OR col.data_type = 'CLOB' THEN
            v_sql := v_sql || 'UPPER(' || col.column_name || ') = UPPER(' || v_val || ')';
        ELSE
            v_sql := v_sql || col.column_name || ' = ' || v_val;
        END IF;

        i := i + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(v_sql);
    EXECUTE IMMEDIATE v_sql;
END;
/
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-51455_Add_field_Stale_Approve_to_Preferences' ;
