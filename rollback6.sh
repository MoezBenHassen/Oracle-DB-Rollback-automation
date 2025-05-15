#!/bin/bash

INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory"
OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output"

mkdir -p "$OUTPUT_DIR"

for sql_file in "$INPUT_DIR"/*.sql; do
    filename=$(basename "$sql_file")
    rollback_file="$OUTPUT_DIR/rollback_$filename"

    echo "Generating rollback for $filename"
    echo "-- 🔁 Rollback of $filename" > "$rollback_file"

    while IFS= read -r line; do
        # Normalize whitespace
        trimmed_line="$(echo "$line" | sed 's/^[[:space:]]*//')"

        # Case-insensitive EXECUTE IMMEDIATE '...ALTER TABLE ... ADD ...'
        if [[ "$trimmed_line" =~ [Ee][Xx][Ee][Cc][Uu][Tt][Ee][[:space:]]+[Ii][Mm][Mm][Ee][Dd][Ii][Aa][Tt][Ee][[:space:]]*\'[[:space:]]*[Aa][Ll][Tt][Ee][Rr][[:space:]]+[Tt][Aa][Bb][Ll][Ee][[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+[Aa][Dd][Dd][[:space:]]+([^\'\;]+) ]]; then
            table="${BASH_REMATCH[1]}"
            col="${BASH_REMATCH[2]}"
            echo "  -- Revert: DROP added column (from EXECUTE IMMEDIATE)" >> "$rollback_file"
            echo "  EXECUTE IMMEDIATE 'ALTER TABLE $table DROP COLUMN ${col%% *}';" >> "$rollback_file"

        # Direct ALTER TABLE ADD (not inside quotes)
        elif [[ "$trimmed_line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+ADD[[:space:]]+([^;]+) ]]; then
            table="${BASH_REMATCH[1]}"
            col="${BASH_REMATCH[2]}"
            echo "  -- Revert: DROP added column" >> "$rollback_file"
            echo "  ALTER TABLE $table DROP COLUMN ${col%% *};" >> "$rollback_file"

        # ALTER TABLE DROP COLUMN
        elif [[ "$trimmed_line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+DROP[[:space:]]+COLUMN[[:space:]]+([^;]+) ]]; then
            echo "  -- Original DROP COLUMN detected, manual revert required: $trimmed_line" >> "$rollback_file"

        # ALTER TABLE MODIFY
        elif [[ "$trimmed_line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+MODIFY[[:space:]]+([^;]+) ]]; then
            echo "  -- MODIFY detected, manual revert required" >> "$rollback_file"
            echo "  -- $trimmed_line" >> "$rollback_file"

        # EXECUTE IMMEDIATE 'ALTER TABLE ... MODIFY ...'
        elif [[ "$trimmed_line" =~ [Ee][Xx][Ee][Cc][Uu][Tt][Ee][[:space:]]+[Ii][Mm][Mm][Ee][Dd][Ii][Aa][Tt][Ee][[:space:]]*\'[[:space:]]*[Aa][Ll][Tt][Ee][Rr][[:space:]]+[Tt][Aa][Bb][Ll][Ee][[:space:]]+[a-zA-Z0-9_]+[[:space:]]+[Mm][Oo][Dd][Ii][Ff][Yy][[:space:]]+.* ]]; then
            echo "  -- MODIFY inside EXECUTE IMMEDIATE detected, manual revert required" >> "$rollback_file"
            echo "  -- $trimmed_line" >> "$rollback_file"

        # INSERT INTO ... (columns) VALUES (...)
        elif [[ "$trimmed_line" =~ INSERT[[:space:]]+INTO[[:space:]]+([a-zA-Z_0-9]+)[[:space:]]*\(([^\)]+)\)[[:space:]]*VALUES[[:space:]]*\(([^\)]+)\) ]]; then
            table="${BASH_REMATCH[1]}"
            columns="${BASH_REMATCH[2]}"
            values="${BASH_REMATCH[3]}"

            IFS=',' read -ra col_array <<< "$columns"
            IFS=',' read -ra val_array <<< "$values"

            if [ "${#col_array[@]}" -eq "${#val_array[@]}" ]; then
                where_clause=""
                for i in "${!col_array[@]}"; do
                    col_name="$(echo "${col_array[$i]}" | sed -E "s/^[[:space:]]+//; s/[[:space:]]+$//")"
                    val="$(echo "${val_array[$i]}" | sed -E "s/^[[:space:]]+//; s/[[:space:]]+$//")"
                    where_clause+="$col_name = $val AND "
                done
                where_clause="${where_clause%AND }"
                echo "  -- Revert: DELETE inserted row" >> "$rollback_file"
                echo "  DELETE FROM $table WHERE $where_clause;" >> "$rollback_file"
            else
                echo "  -- INSERT parse error (column/value count mismatch): $trimmed_line" >> "$rollback_file"
            fi
        else
            echo "$line" >> "$rollback_file"
        fi
    done < "$sql_file"
done

echo "Rollback scripts generated in $OUTPUT_DIR"