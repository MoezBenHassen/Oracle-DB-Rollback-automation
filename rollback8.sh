#!/bin/bash

INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/25.2.0.0"
OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/25.2.0.0"

mkdir -p "$OUTPUT_DIR"

for sql_file in "$INPUT_DIR"/*.sql; do
    filename=$(basename "$sql_file")
    rollback_file="$OUTPUT_DIR/rollback_$filename"

    echo "Generating rollback for $filename"
    echo "-- 🔁 Rollback of $filename" > "$rollback_file"

    declare -A var_map  # Clear var map for each file

    while IFS= read -r line; do
        trimmed_line="$(echo "$line" | sed 's/^[[:space:]]*//')"
        normalized_line="$(echo "$trimmed_line" | tr '[:upper:]' '[:lower:]')"

        # Capture variable assignments like: v_module := 'collateral';
        if [[ "$trimmed_line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)[^:]*:=\ *\'([^\']*)\' ]]; then
            var_name="${BASH_REMATCH[1]}"
            var_value="${BASH_REMATCH[2]}"
            var_map["$var_name"]="$var_value"
            continue
        fi

        # EXECUTE IMMEDIATE 'ALTER TABLE ... ADD ...'
        if [[ "$trimmed_line" =~ [Ee][Xx][Ee][Cc][Uu][Tt][Ee][[:space:]]+[Ii][Mm][Mm][Ee][Dd][Ii][Aa][Tt][Ee][[:space:]]*\'[[:space:]]*[Aa][Ll][Tt][Ee][Rr][[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+ADD[[:space:]]+([a-zA-Z0-9_]+) ]]; then
            table="${BASH_REMATCH[1]}"
            column="${BASH_REMATCH[2]}"
            echo "ALTER TABLE $table DROP COLUMN $column;" >> "$rollback_file"
            continue
        fi

        # Direct ALTER TABLE ADD
        if [[ "$trimmed_line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+ADD[[:space:]]+([a-zA-Z0-9_]+) ]]; then
            table="${BASH_REMATCH[1]}"
            column="${BASH_REMATCH[2]}"
            echo "ALTER TABLE $table DROP COLUMN $column;" >> "$rollback_file"
            continue
        fi

        # INSERT INTO (columns) VALUES (...) — now with variable resolution
        if [[ "$trimmed_line" =~ INSERT[[:space:]]+INTO[[:space:]]+([a-zA-Z0-9_]+).*VALUES.* ]]; then
            table="${BASH_REMATCH[1]}"

            # Extract columns and values using sed
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

                        # Resolve variable if needed
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

        # INSERT INTO table VALUES (...) — unsupported
        if [[ "$trimmed_line" =~ [Ii][Nn][Ss][Ee][Rr][Tt][[:space:]]+INTO[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+VALUES[[:space:]]*\(.*\) ]]; then
            table="${BASH_REMATCH[1]}"
            echo "-- INSERT INTO $table without column names. Manual rollback required." >> "$rollback_file"
            continue
        fi

        # Skip all other lines
        continue
    done < "$sql_file"
done

echo "Rollback scripts generated in $OUTPUT_DIR"
