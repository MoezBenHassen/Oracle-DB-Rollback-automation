#!/bin/bash

INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory"
OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output"

mkdir -p "$OUTPUT_DIR"

# Define the regular expression pattern
insert_regex="INSERT[[:space:]]+INTO[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]*\(([^)]*)\)[[:space:]]*VALUES[[:space:]]*\(([^)]*)\)"

for sql_file in "$INPUT_DIR"/*.sql; do
    filename=$(basename "$sql_file")
    rollback_file="$OUTPUT_DIR/rollback_$filename"

    echo "DECLARE" > "$rollback_file"
    echo "  results    NUMBER;" >> "$rollback_file"
    echo "  v_module   VARCHAR2(100);" >> "$rollback_file"
    echo "  v_property VARCHAR2(100);" >> "$rollback_file"
    echo "BEGIN" >> "$rollback_file"

    v_module=""
    v_property=""

    while IFS= read -r line; do
        # Extract v_module
        if [[ $line =~ v_module[[:space:]]*:=[[:space:]]*\'([^\']+)\' ]]; then
            v_module="${BASH_REMATCH[1]}"
            echo "  v_module := '${v_module}';" >> "$rollback_file"
        fi

        # Extract v_property
        if [[ $line =~ v_property[[:space:]]*:=[[:space:]]*\'([^\']+)\' ]]; then
            v_property="${BASH_REMATCH[1]}"
            echo "  v_property := '${v_property}';" >> "$rollback_file"
        fi

        # Handle EXECUTE IMMEDIATE statements
        if [[ $line =~ EXECUTE[[:space:]]+IMMEDIATE[[:space:]]*\'([^\']+)\' ]]; then
            stmt="${BASH_REMATCH[1]}"
            # Invert ALTER TABLE ADD COLUMN to DROP COLUMN
            if [[ $stmt =~ ALTER[[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+ADD[[:space:]]+([a-zA-Z0-9_]+) ]]; then
                table="${BASH_REMATCH[1]}"
                column="${BASH_REMATCH[2]}"
                echo "  EXECUTE IMMEDIATE 'ALTER TABLE ${table} DROP COLUMN ${column}';" >> "$rollback_file"
            fi
            # Invert ALTER TABLE DROP COLUMN to ADD COLUMN (Note: Requires original column definition)
            if [[ $stmt =~ ALTER[[:space:]]+TABLE[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+DROP[[:space:]]+COLUMN[[:space:]]+([a-zA-Z0-9_]+) ]]; then
                table="${BASH_REMATCH[1]}"
                column="${BASH_REMATCH[2]}"
                echo "  -- Original column definition required to revert DROP COLUMN on ${table}.${column}" >> "$rollback_file"
            fi
        fi

        # Handle INSERT INTO statements
        if [[ $line =~ $insert_regex ]]; then
            table="${BASH_REMATCH[1]}"
            columns="${BASH_REMATCH[2]}"
            values="${BASH_REMATCH[3]}"
            # Construct DELETE statement based on v_module and v_property
            if [[ "$table" == "lrsschemaproperties" ]]; then
                echo "  DELETE FROM ${table} WHERE modulename = v_module AND propertyname = v_property;" >> "$rollback_file"
            else
                echo "  -- DELETE FROM ${table} WHERE <appropriate condition>;" >> "$rollback_file"
            fi
        fi
    done < "$sql_file"

    echo "  COMMIT;" >> "$rollback_file"
    echo "END;" >> "$rollback_file"
    echo "/" >> "$rollback_file"
done
