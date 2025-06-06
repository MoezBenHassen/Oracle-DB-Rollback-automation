#!/bin/bash

INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/25.2.0.0"
OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/25.2.0.0"

mkdir -p "$OUTPUT_DIR"

for sql_file in "$INPUT_DIR"/*.sql; do
    filename=$(basename "$sql_file")
    rollback_file="$OUTPUT_DIR/rollback_$filename"

    echo "Generating rollback for $filename"
    echo "-- 🔁 Rollback of $filename" > "$rollback_file"

    while IFS= read -r line; do
        # Normalize whitespace
        trimmed_line="$(echo "$line" | sed 's/^[[:space:]]*//')"

        # EXECUTE IMMEDIATE '...ALTER TABLE ... ADD ...'
        if [[ "$trimmed_line" =~ [Ee][Xx][Ee][Cc][Uu][Tt][Ee][[:space:]]+[Ii][Mm][Mm][Ee][Dd][Ii][Aa][Tt][Ee][[:space:]]*\'[[:space:]]*[Aa][Ll][Tt][Ee][Rr][[:space:]]+[Tt][Aa][Bb][Ll][Ee][[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+[Aa][Dd][Dd][[:space:]]+([^\'\;]+) ]]; then
            table="${BASH_REMATCH[1]}"
            col="${BASH_REMATCH[2]}"
            echo "  -- Revert: DROP added column (from EXECUTE IMMEDIATE)" >> "$rollback_file"
            echo "  EXECUTE IMMEDIATE 'ALTER TABLE $table DROP COLUMN ${col%% *}';" >> "$rollback_file"
            continue

        # Direct ALTER TABLE ADD
        elif [[ "$trimmed_line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+ADD[[:space:]]+([^;]+) ]]; then
            table="${BASH_REMATCH[1]}"
            col="${BASH_REMATCH[2]}"
            echo "  -- Revert: DROP added column" >> "$rollback_file"
            echo "  ALTER TABLE $table DROP COLUMN ${col%% *};" >> "$rollback_file"
            continue

        # ALTER TABLE DROP COLUMN
        elif [[ "$trimmed_line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+DROP[[:space:]]+COLUMN[[:space:]]+([^;]+) ]]; then
            echo "  -- Original DROP COLUMN detected, manual revert required: $trimmed_line" >> "$rollback_file"
            continue

        # ALTER TABLE MODIFY
        elif [[ "$trimmed_line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+MODIFY[[:space:]]+([^;]+) ]]; then
            echo "  -- MODIFY detected, manual revert required" >> "$rollback_file"
            echo "  -- $trimmed_line" >> "$rollback_file"
            continue

        # EXECUTE IMMEDIATE 'ALTER TABLE ... MODIFY ...'
        elif [[ "$trimmed_line" =~ [Ee][Xx][Ee][Cc][Uu][Tt][Ee][[:space:]]+[Ii][Mm][Mm][Ee][Dd][Ii][Aa][Tt][Ee][[:space:]]*\'[[:space:]]*[Aa][Ll][Tt][Ee][Rr][[:space:]]+[Tt][Aa][Bb][Ll][Ee][[:space:]]+[a-zA-Z0-9_]+[[:space:]]+[Mm][Oo][Dd][Ii][Ff][Yy][[:space:]]+.* ]]; then
            echo "  -- MODIFY inside EXECUTE IMMEDIATE detected, manual revert required" >> "$rollback_file"
            echo "  -- $trimmed_line" >> "$rollback_file"
            continue

        # INSERT INTO (columns) VALUES (...)
        elif [[ "$trimmed_line" =~ INSERT[[:space:]]+INTO[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]*\(([^\)]+)\)[[:space:]]*VALUES[[:space:]]*\(([^\)]+)\) ]]; then
            table="${BASH_REMATCH[1]}"
            columns="${BASH_REMATCH[2]}"
            values="${BASH_REMATCH[3]}"

            IFS=',' read -ra col_array <<< "$columns"
            IFS=',' read -ra val_array <<< "$values"

            if [ "${#col_array[@]}" -eq "${#val_array[@]}" ]; then
                where_clause=""
                for i in "${!col_array[@]}" ; do
                    col_name="$(echo "${col_array[$i]}" | sed -E "s/^[[:space:]]+//;s/[[:space:]]+$//")"
                    val="$(echo "${val_array[$i]}" | sed -E "s/^[[:space:]]+//;s/[[:space:]]+$//")"
                    if [[ "$val" =~ ^null$|^NULL$ ]]; then
                        where_clause+="$col_name IS NULL AND "
                    else
                        where_clause+="$col_name = $val AND "
                    fi
                done
                where_clause="${where_clause%AND }"
                echo "  -- Revert: DELETE inserted row" >> "$rollback_file"
                echo "  DELETE FROM $table WHERE $where_clause;" >> "$rollback_file"
            else
                echo "  -- INSERT parse error (column/value count mismatch): $trimmed_line" >> "$rollback_file"
            fi
            continue

# INSERT INTO table VALUES (...) ← handled dynamically at runtime via metadata
elif [[ "$trimmed_line" =~ [Ii][Nn][Ss][Ee][Rr][Tt][[:space:]]+[Ii][Nn][Tt][Oo][[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+[Vv][Aa][Ll][Uu][Ee][Ss][[:space:]]*\((.*)\) ]]; then
    table="${BASH_REMATCH[1]}"
    values="${BASH_REMATCH[2]}"

    echo "  -- Revert: DELETE inserted row (dynamic column resolution at runtime)" >> "$rollback_file"
    echo "DECLARE" >> "$rollback_file"
    echo "  v_sql VARCHAR2(4000);" >> "$rollback_file"
    echo "BEGIN" >> "$rollback_file"
    echo "  SELECT 'DELETE FROM $table WHERE ' ||" >> "$rollback_file"
    echo "         LISTAGG(column_name || ' = ' || '/* map value here */', ' AND ')" >> "$rollback_file"
    echo "         WITHIN GROUP (ORDER BY column_id)" >> "$rollback_file"
    echo "  INTO v_sql" >> "$rollback_file"
    echo "  FROM all_tab_columns" >> "$rollback_file"
    echo "  WHERE table_name = UPPER('$table')" >> "$rollback_file"
    echo "    AND owner = USER;" >> "$rollback_file"
    echo "" >> "$rollback_file"
    echo "  -- Print or execute" >> "$rollback_file"
    echo "  DBMS_OUTPUT.PUT_LINE(v_sql);" >> "$rollback_file"
    echo "  -- EXECUTE IMMEDIATE v_sql;" >> "$rollback_file"
    echo "END;" >> "$rollback_file"
    echo "/" >> "$rollback_file"
    continue


        else
            echo "$line" >> "$rollback_file"
        fi
    done < "$sql_file"
done

echo "Rollback scripts generated in $OUTPUT_DIR"
