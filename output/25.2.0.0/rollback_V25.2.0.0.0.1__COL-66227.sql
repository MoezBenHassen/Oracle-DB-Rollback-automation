-- 🔁 Rollback of V25.2.0.0.0.1__COL-66227.sql
-- Revert: DELETE from moeztest using metadata and input values
WITH
    input_values AS (
        SELECT '2, ''smith'', ''jane'', ''456 oak st'', ''springfield''' AS values_str FROM dual
    ),
    column_list AS (
        SELECT column_name, rownum AS rn
        FROM (
            SELECT column_name
            FROM all_tab_columns
            WHERE table_name = UPPER('moeztest') AND owner = USER
            ORDER BY column_id
        )
    ),
    value_list AS (
        SELECT TRIM(REGEXP_SUBSTR(values_str, '[^,]+', 1, LEVEL)) AS value, LEVEL AS rn
        FROM input_values
        CONNECT BY LEVEL <= REGEXP_COUNT(values_str, ',') + 1
    ),
    combined AS (
        SELECT c.column_name, v.value
        FROM column_list c
        JOIN value_list v ON c.rn = v.rn
    )
SELECT 'DELETE FROM moeztest WHERE ' ||
       LISTAGG(column_name || ' = ' || value, ' AND ') WITHIN GROUP (ORDER BY column_name)
       || ';' AS rollback_query
FROM combined;
