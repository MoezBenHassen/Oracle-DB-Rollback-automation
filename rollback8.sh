#!/bin/bash

INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/25.2.0.0"
OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/25.2.0.0"

mkdir -p "$OUTPUT_DIR"

for sql_file in "$INPUT_DIR"/*.sql; do
    filename=$(basename "$sql_file")
    rollback_file="$OUTPUT_DIR/rollback_$filename"

    echo "Generating rollback for $filename"
    echo "-- 🔁 Rollback of $filename" > "$rollback_file"

    declare -A var_map  # Reset var map for each file

    while IFS= read -r line; do
        trimmed_line="$(echo "$line" | sed 's/^[[:space:]]*//')"
        normalized_line="$(echo "$trimmed_line" | tr '[:upper:]' '[:lower:]')"

        # Variable assignment
        if [[ "$trimmed_line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)[^:]*:=\ *\'([^\']*)\' ]]; then
            var_name="${BASH_REMATCH[1]}"
            var_value="${BASH_REMATCH[2]}"
            var_map["$var_name"]="$var_value"
            continue
        fi

        # EXECUTE IMMEDIATE 'ALTER TABLE ... ADD ...'
        if [[ "$normalized_line" =~ execute[[:space:]]+immediate[[:space:]]*\'[[:space:]]*alter[[:space:]]+table[[:space:]]+([a-z0-9_]+)[[:space:]]+add[[:space:]]+([a-z0-9_]+) ]]; then
            table="${BASH_REMATCH[1]}"
            column="${BASH_REMATCH[2]}"
            echo "ALTER TABLE $table DROP COLUMN $column;" >> "$rollback_file"
            continue
        fi

        # ALTER TABLE ADD ...
        if [[ "$normalized_line" =~ alter[[:space:]]+table[[:space:]]+([a-z0-9_]+)[[:space:]]+add[[:space:]]+([a-z0-9_]+) ]]; then
            table="${BASH_REMATCH[1]}"
            column="${BASH_REMATCH[2]}"
            echo "ALTER TABLE $table DROP COLUMN $column;" >> "$rollback_file"
            continue
        fi

        # INSERT INTO (...) VALUES (...) with column names
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
                        col_name="$(echo "${col_array[$i]}" | xargs)"
                        raw_val="$(echo "${val_array[$i]}" | xargs)"
                        if [[ "$raw_val" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ && -n "${var_map[$raw_val]}" ]]; then
                            val="'${var_map[$raw_val]}'"
                        else
                            val="$raw_val"
                        fi
                        [[ "$val" =~ ^null$|^NULL$ ]] && where_clause+="$col_name IS NULL AND " || where_clause+="$col_name = $val AND "
                    done
                    where_clause="${where_clause%AND }"
                    echo "DELETE FROM $table WHERE $where_clause;" >> "$rollback_file"
                else
                    echo "-- INSERT rollback failed: column/value count mismatch" >> "$rollback_file"
                fi
                continue
            fi
        fi

        # INSERT INTO table VALUES (...) — use Oracle metadata and escape quotes
        if [[ "$normalized_line" =~ insert[[:space:]]+into[[:space:]]+([a-z0-9_]+)[[:space:]]+values[[:space:]]*\((.*)\) ]]; then
            table="${BASH_REMATCH[1]}"
            raw_values="${BASH_REMATCH[2]}"
            escaped_values=$(echo "$raw_values" | sed "s/'/''/g")

            echo "-- Revert: DELETE from $table using metadata and input values" >> "$rollback_file"
            echo "WITH" >> "$rollback_file"
            echo "    input_values AS (" >> "$rollback_file"
            echo "        SELECT '$escaped_values' AS values_str FROM dual" >> "$rollback_file"
            echo "    )," >> "$rollback_file"
            echo "    column_list AS (" >> "$rollback_file"
            echo "        SELECT column_name, rownum AS rn" >> "$rollback_file"
            echo "        FROM (" >> "$rollback_file"
            echo "            SELECT column_name" >> "$rollback_file"
            echo "            FROM all_tab_columns" >> "$rollback_file"
            echo "            WHERE table_name = UPPER('$table') AND owner = USER" >> "$rollback_file"
            echo "            ORDER BY column_id" >> "$rollback_file"
            echo "        )" >> "$rollback_file"
            echo "    )," >> "$rollback_file"
            echo "    value_list AS (" >> "$rollback_file"
            echo "        SELECT TRIM(REGEXP_SUBSTR(values_str, '[^,]+', 1, LEVEL)) AS value, LEVEL AS rn" >> "$rollback_file"
            echo "        FROM input_values" >> "$rollback_file"
            echo "        CONNECT BY LEVEL <= REGEXP_COUNT(values_str, ',') + 1" >> "$rollback_file"
            echo "    )," >> "$rollback_file"
            echo "    combined AS (" >> "$rollback_file"
            echo "        SELECT c.column_name, v.value" >> "$rollback_file"
            echo "        FROM column_list c" >> "$rollback_file"
            echo "        JOIN value_list v ON c.rn = v.rn" >> "$rollback_file"
            echo "    )" >> "$rollback_file"
            echo "SELECT 'DELETE FROM $table WHERE ' ||" >> "$rollback_file"
            echo "       LISTAGG(column_name || ' = ' || value, ' AND ') WITHIN GROUP (ORDER BY column_name)" >> "$rollback_file"
            echo "       || ';' AS rollback_query" >> "$rollback_file"
            echo "FROM combined;" >> "$rollback_file"
            continue
        fi

        continue  # Ignore all other lines
    done < "$sql_file"
done

echo "Rollback scripts generated in $OUTPUT_DIR"
