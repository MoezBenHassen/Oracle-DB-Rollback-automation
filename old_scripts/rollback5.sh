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
        # ALTER TABLE ADD
        if [[ "$line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([^[:space:]]+)[[:space:]]+ADD[[:space:]]+([^;]+) ]]; then
            table="${BASH_REMATCH[1]}"
            col="${BASH_REMATCH[2]}"
            echo "  -- Revert: DROP added column" >> "$rollback_file"
            echo "  EXECUTE IMMEDIATE 'ALTER TABLE $table DROP COLUMN ${col%% *}';" >> "$rollback_file"

        # ALTER TABLE DROP COLUMN
        elif [[ "$line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([^[:space:]]+)[[:space:]]+DROP[[:space:]]+COLUMN[[:space:]]+([^;]+) ]]; then
            echo "  -- Original DROP COLUMN detected, manual revert required: $line" >> "$rollback_file"

        # ALTER TABLE MODIFY
        elif [[ "$line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([^[:space:]]+)[[:space:]]+MODIFY[[:space:]]+([^;]+) ]]; then
            echo "  -- MODIFY detected, manual revert required" >> "$rollback_file"
            echo "  -- $line" >> "$rollback_file"

        # INSERT INTO ... (columns) VALUES (...)
        elif [[ "$line" =~ INSERT[[:space:]]+INTO[[:space:]]+([a-zA-Z_0-9]+)[[:space:]]*\(([^\)]+)\)[[:space:]]*VALUES[[:space:]]*\(([^\)]+)\) ]]; then
            table="${BASH_REMATCH[1]}"
            columns="${BASH_REMATCH[2]}"
            values="${BASH_REMATCH[3]}"

            # Clean and split columns and values
            IFS=',' read -ra col_array <<< "$columns"
            IFS=',' read -ra val_array <<< "$values"

            # Build WHERE clause
            where_clause=""
            for i in "${!col_array[@]}"; do
                col_name=$(echo "${col_array[$i]}" | xargs)
                val="$(echo "${val_array[$i]}" | sed -E "s/^[[:space:]]+//; s/[[:space:]]+$//")"
                where_clause+="$col_name = $val AND "
            done
            where_clause="${where_clause%AND }"

            echo "  -- Revert: DELETE inserted row" >> "$rollback_file"
            echo "  DELETE FROM $table WHERE $where_clause;" >> "$rollback_file"

        else
            echo "$line" >> "$rollback_file"
        fi
    done < "$sql_file"

    echo "  COMMIT;" >> "$rollback_file"
    echo "END;" >> "$rollback_file"
done

echo "Rollback scripts generated in $OUTPUT_DIR"
