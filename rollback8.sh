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
        trimmed_line="$(echo "$line" | sed 's/^[[:space:]]*//')"

        # EXECUTE IMMEDIATE 'ALTER TABLE ... ADD ...'
        if [[ "$trimmed_line" =~ [Ee][Xx][Ee][Cc][Uu][Tt][Ee][[:space:]]+[Ii][Mm][Mm][Ee][Dd][Ii][Aa][Tt][Ee][[:space:]]*\'[[:space:]]*[Aa][Ll][Tt][Ee][Rr][[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+ADD[[:space:]]+([a-zA-Z0-9_]+) ]]; then
            table="${BASH_REMATCH[1]}"
            column="${BASH_REMATCH[2]}"
            echo "ALTER TABLE $table DROP COLUMN $column;" >> "$rollback_file"
            continue

        # Direct ALTER TABLE ADD
        elif [[ "$trimmed_line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+ADD[[:space:]]+([a-zA-Z0-9_]+) ]]; then
            table="${BASH_REMATCH[1]}"
            column="${BASH_REMATCH[2]}"
            echo "ALTER TABLE $table DROP COLUMN $column;" >> "$rollback_file"
            continue

        # INSERT INTO (columns) VALUES (...)
        elif [[ "$trimmed_line" =~ INSERT[[:space:]]+INTO[[:space:]]+([a-zA-Z_0-9]+)[[:space:]]*\(([^)]+)\)[[:space:]]*VALUES[[:space:]]*\(([^)]+)\) ]]; then
            table="${BASH_REMATCH[1]}"
            columns="${BASH_REMATCH[2]}"
            values="${BASH_REMATCH[3]}"

            IFS=',' read -ra col_array <<< "$columns"
            IFS=',' read -ra val_array <<< "$values"

            if [[ ${#col_array[@]} -eq ${#val_array[@]} ]]; then
                where_clause=""
                for i in "${!col_array[@]}"; do
                    col_name="$(echo "${col_array[$i]}" | xargs)"
                    val="$(echo "${val_array[$i]}" | xargs)"
                    [[ "$val" =~ ^null$|^NULL$ ]] && where_clause+="$col_name IS NULL AND " || where_clause+="$col_name = $val AND "
                done
                where_clause="${where_clause%AND }"
                echo "DELETE FROM $table WHERE $where_clause;" >> "$rollback_file"
            fi
            continue

        # INSERT INTO table VALUES (...) → unsupported due to missing column info
        elif [[ "$trimmed_line" =~_]()]()
