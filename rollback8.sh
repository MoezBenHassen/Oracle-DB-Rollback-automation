#!/bin/bash

INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/25.2.0.0"
OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/25.2.0.0"

mkdir -p "$OUTPUT_DIR"

for sql_file in "$INPUT_DIR"/*.sql; do
    filename=$(basename "$sql_file")
    rollback_file="$OUTPUT_DIR/rollback_$filename"

    echo "Generating rollback for $filename"
    echo "-- 🔁 Rollback of $filename" > "$rollback_file"

    declare -A var_map

    while IFS= read -r line; do
        trimmed_line="$(echo "$line" | sed 's/^[[:space:]]*//')"
        normalized_line="$(echo "$trimmed_line" | tr '[:upper:]' '[:lower:]')"

        # Variable assignment
        if [[ "$trimmed_line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)[^:]*:=\ *\'([^\']*)\' ]]; then
            var_map["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
            continue
        fi

        # ALTER TABLE via EXECUTE IMMEDIATE
        if [[ "$normalized_line" =~ execute[[:space:]]+immediate.*alter[[:space:]]+table[[:space:]]+([a-z0-9_]+)[[:space:]]+add[[:space:]]+([a-z0-9_]+) ]]; then
            echo "ALTER TABLE ${BASH_REMATCH[1]} DROP COLUMN ${BASH_REMATCH[2]};" >> "$rollback_file"
            continue
        fi

        # Direct ALTER TABLE ADD
        if [[ "$normalized_line" =~ alter[[:space:]]+table[[:space:]]+([a-z0-9_]+)[[:space:]]+add[[:space:]]+([a-z0-9_]+) ]]; then
            echo "ALTER TABLE ${BASH_REMATCH[1]} DROP COLUMN ${BASH_REMATCH[2]};" >> "$rollback_file"
            continue
        fi

        # INSERT INTO (...) VALUES (...)
        if [[ "$normalized_line" =~ insert[[:space:]]+into[[:space:]]+([a-z0-9_]+).*values.* ]]; then
            table="${BASH_REMATCH[1]}"
            columns=$(echo "$trimmed_line" | sed -nE "s/.*INTO[[:space:]]+$table[[:space:]]*\(([^)]+)\)[[:space:]]*VALUES.*/\1/p")
            values=$(echo "$trimmed_line" | sed -nE "s/.*VALUES[[:space:]]*\(([^)]+)\).*/\1/p")

            if [[ -n "$columns" && -n "$values" ]]; then
                IFS=',' read -ra col_array <<< "$columns"
                IFS=',' read -ra val_array <<< "$values"

                if [[ ${#col_array[@]} -eq ${#val_array[@]} ]]; then
                    where_clause=""
                    for i in "${!col_array[@]}"; do
                        col="$(echo "${col_array[$i]}" | xargs)"
                        raw_val="$(echo "${val_array[$i]}" | xargs)"
                        if [[ "$raw_val" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ && -n "${var_map[$raw_val]}" ]]; then
                            val="'${var_map[$raw_val]}'"
                        else
                            val="$raw_val"
                        fi
                        [[ "$val" =~ ^null$|^NULL$ ]] && where_clause+="$col IS NULL AND " || where_clause+="$col = $val AND "
                    done
                    where_clause="${where_clause%AND }"
                    echo "DELETE FROM $table WHERE $where_clause;" >> "$rollback_file"
                fi
                continue
            fi
        fi

        # INSERT INTO table VALUES (...) — PL/SQL-based rollback
        if [[ "$normalized_line" =~ insert[[:space:]]+into[[:space:]]+([a-z0-9_]+)[[:space:]]+values[[:space:]]*\((.*)\) ]]; then
            table="${BASH_REMATCH[1]}"
            raw_values="${BASH_REMATCH[2]}"
            escaped_values=$(echo "$raw_values" | sed "s/'/''/g")
cat >> "$rollback_file" <<EOF
-- Revert: DELETE from $table using PL/SQL metadata lookup
DECLARE
    v_sql   CLOB := 'DELETE FROM $table WHERE ';
    v_vals  CLOB := '$escaped_values';
    i       PLS_INTEGER := 1;
    v_val   VARCHAR2(4000);
    first   BOOLEAN := TRUE;
BEGIN
    FOR col IN (
        SELECT column_name, data_type
        FROM all_tab_columns
        WHERE table_name = UPPER('$table')
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
            -- For string types: compare with UPPER() to match insensitively
            v_sql := v_sql || 'UPPER(' || col.column_name || ') = UPPER(' || v_val || ')';
        ELSE
            -- For numeric/date types: compare directly
            v_sql := v_sql || col.column_name || ' = ' || v_val;
        END IF;

        i := i + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(v_sql);
    EXECUTE IMMEDIATE v_sql;
END;
/
EOF

            continue
        fi

    done < "$sql_file"
done

echo "Rollback scripts generated in $OUTPUT_DIR"
