#!/bin/bash

INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory"
OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output"

mkdir -p "$OUTPUT_DIR"

for sql_file in "$INPUT_DIR"/*.sql; do
    filename=$(basename "$sql_file")
    rollback_file="$OUTPUT_DIR/rollback_$filename"

    echo "Generating rollback for $filename"

    echo "DECLARE" > "$rollback_file"
    echo "  results    NUMBER;" >> "$rollback_file"
    echo "  v_module   VARCHAR2(100);" >> "$rollback_file"
    echo "  v_property VARCHAR2(100);" >> "$rollback_file"
    echo "BEGIN" >> "$rollback_file"

    while IFS= read -r line; do
        if [[ "$line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([^[:space:]]+)[[:space:]]+ADD[[:space:]]+([^;]+) ]]; then
            table="${BASH_REMATCH[1]}"
            col="${BASH_REMATCH[2]}"
            echo "  -- Revert: DROP added column" >> "$rollback_file"
            echo "  EXECUTE IMMEDIATE 'ALTER TABLE $table DROP COLUMN ${col%% *}';" >> "$rollback_file"
        elif [[ "$line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([^[:space:]]+)[[:space:]]+DROP[[:space:]]+COLUMN[[:space:]]+([^;]+) ]]; then
            echo "  -- Original DROP COLUMN detected, manual revert required: $line" >> "$rollback_file"
        elif [[ "$line" =~ ALTER[[:space:]]+TABLE[[:space:]]+([^[:space:]]+)[[:space:]]+MODIFY[[:space:]]+([^;]+) ]]; then
            echo "  -- MODIFY detected, manual revert required" >> "$rollback_file"
            echo "  -- $line" >> "$rollback_file"
        elif [[ "$line" =~ INSERT[[:space:]]+INTO[[:space:]]+([^[:space:]]+) ]]; then
            table="${BASH_REMATCH[1]}"
            echo "  -- Revert: DELETE inserted row (manual where clause needed)" >> "$rollback_file"
            echo "  -- Consider: DELETE FROM $table WHERE [CONDITION];" >> "$rollback_file"
        else
            echo "$line" >> "$rollback_file"
        fi
    done < "$sql_file"

    echo "  COMMIT;" >> "$rollback_file"
    echo "END;" >> "$rollback_file"
done

echo "Rollback scripts generated in $OUTPUT_DIR"
