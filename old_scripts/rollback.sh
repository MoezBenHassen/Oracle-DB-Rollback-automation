#!/bin/bash

INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory"
OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output"

mkdir -p "$OUTPUT_DIR"

for sql_file in "$INPUT_DIR"/*.sql; do
    filename=$(basename "$sql_file")
    rollback_file="$OUTPUT_DIR/rollback_$filename"

    echo "-- Rollback script for $filename" > "$rollback_file"

    while IFS= read -r line; do
        # Handle INSERT INTO statements
        if [[ $line =~ INSERT[[:space:]]+INTO[[:space:]]+([a-zA-Z0-9_]+) ]]; then
            table="${BASH_REMATCH[1]}"
            echo "DELETE FROM $table WHERE <condition>;" >> "$rollback_file"
        fi

        # Handle ALTER TABLE ADD COLUMN statements
        if [[ $line =~ ALTER[[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+ADD[[:space:]]+([a-zA-Z0-9_]+) ]]; then
            table="${BASH_REMATCH[1]}"
            column="${BASH_REMATCH[2]}"
            echo "ALTER TABLE $table DROP COLUMN $column;" >> "$rollback_file"
        fi

        # Handle CREATE TABLE statements
        if [[ $line =~ CREATE[[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+) ]]; then
            table="${BASH_REMATCH[1]}"
            echo "DROP TABLE $table;" >> "$rollback_file"
        fi

        # Additional parsing rules can be added here

    done < "$sql_file"
done
