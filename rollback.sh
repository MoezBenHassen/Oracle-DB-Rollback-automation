#!/bin/bash

INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/test/formatted"
OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/test"

# INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/25.2.0.0"
# OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/25.2.0.0/test"

# INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/15.14.0.0"
# OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/15.14.0.0/test"

mkdir -p "$OUTPUT_DIR"

for sql_file in "$INPUT_DIR"/*.sql; do
    filename=$(basename "$sql_file")
    rollback_file="$OUTPUT_DIR/rollback_$filename"

    echo "Generating rollback for $filename"
    echo "-- 🔁 Rollback of $filename" > "$rollback_file"

    declare -A var_map
    declare -A dynamic_sql_vars
    last_v_sql="" # Initialize last_v_sql

    while IFS= read -r line; do
        trimmed_line="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')" # Trim leading/trailing whitespace
        normalized_line="$(echo "$trimmed_line" | tr '[:upper:]' '[:lower:]')"

        # Pattern for := assignment (PL/SQL-style)
        if [[ "$trimmed_line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)[^:=]*:=[[:space:]]*\'([^\']*)\'[[:space:]]*(;[[:space:]]*)?$ ]]; then
            varname="${BASH_REMATCH[1]}"
            varvalue="${BASH_REMATCH[2]}"
            var_map["$varname"]="$varvalue"
            dynamic_sql_vars["$varname"]="$varvalue"
            if [[ "$varname" == "v_sql" ]]; then
                last_v_sql="$varvalue"
            fi
            # echo "DEBUG: PL/SQL var assigned: $varname = $varvalue" >&2 
            continue
        fi

        # Pattern for = assignment (SQL-style)
        if [[ "$trimmed_line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)[^=]*=[[:space:]]*\'([^\']*)\'[[:space:]]*(;[[:space:]]*)?$ ]]; then
            varname="${BASH_REMATCH[1]}"
            varvalue="${BASH_REMATCH[2]}"
            if ! [[ "$(echo "$varname" | tr '[:lower:]' '[:upper:]')" =~ ^(SET|DEFINE|ACCEPT|PROMPT)$ ]]; then
                 var_map["$varname"]="$varvalue"
                 dynamic_sql_vars["$varname"]="$varvalue"
                 if [[ "$varname" == "v_sql" ]]; then
                     last_v_sql="$varvalue"
                 fi
                 # echo "DEBUG: SQL var assigned: $varname = $varvalue" >&2
            fi
            continue
        fi

        # INSERT INTO table(col1, col2) VALUES(...)
        regex_insert_with_cols="insert[[:space:]]+into[[:space:]]+([a-z0-9_.]+)[[:space:]]*\(([^)]+)\)[[:space:]]*values[[:space:]]*\(([^)]+)\)"
        if [[ "$normalized_line" =~ $regex_insert_with_cols ]]; then
            table="${BASH_REMATCH[1]}"
            columns_norm="${BASH_REMATCH[2]}" 
            
            values_str_orig_case=$(echo "$trimmed_line" | sed -nE "s/.*[vV][aA][lL][uU][eE][sS][[:space:]]*\((.*)\)[[:space:]]*;?[[:space:]]*$/\1/p")

            if [[ -n "$columns_norm" && -n "$values_str_orig_case" ]]; then
                IFS=',' read -ra col_array <<< "$columns_norm"
                IFS=',' read -ra val_array <<< "$values_str_orig_case"

                if [[ ${#col_array[@]} -eq ${#val_array[@]} ]]; then
                    where_clause=""
                    for i in "${!col_array[@]}"; do
                        col="$(echo "${col_array[$i]}" | xargs)"
                        raw_val="$(echo "${val_array[$i]}" | xargs)"

                        if [[ "$raw_val" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]] && [[ -v var_map[$raw_val] ]]; then
                            val="'${var_map[$raw_val]}'"
                        elif [[ "$raw_val" =~ ^\'.*\'$ || "$raw_val" =~ ^[0-9]+(\.[0-9]+)?$ || "$(echo "$raw_val" | tr '[:upper:]' '[:lower:]')" == "null" ]]; then
                            val="$raw_val"
                        else
                            val="'$raw_val'"
                        fi
                        
                        if [[ "$(echo "$val" | tr '[:upper:]' '[:lower:]')" == "null" || "$(echo "$val" | tr '[:upper:]' '[:lower:]')" == "'null'" ]]; then
                             where_clause+="$col IS NULL AND "
                        else
                             where_clause+="$col = $val AND "
                        fi
                    done
                    where_clause="${where_clause%AND }"
                    echo "DELETE FROM $table WHERE $where_clause;" >> "$rollback_file"
                    continue
                fi
            fi
        fi
        
        # REMOVED THE INTERMEDIATE "Fallback INSERT" BLOCK THAT WAS HERE.
        # The INSERT without explicit columns will now be handled by the PL/SQL generator block further down.

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

        # Catch any UPDATE statement
        if [[ "$normalized_line" =~ update[[:space:]]+[a-z0-9_]+[[:space:]]+set[[:space:]]+ ]]; then
            echo "-- ⚠️ MANUAL CHECK REQUIRED: the following UPDATE needs to be manually rolledback" >> "$rollback_file"
            echo "-- ORIGINAL: $trimmed_line" >> "$rollback_file"
            continue
        fi

        # Track dynamic SQL assigned to any variable (e.g. v_sql for EXECUTE IMMEDIATE)
        # This check is primarily for populating dynamic_sql_vars if it wasn't already
        # by the main := or = assignment blocks (which now also populate dynamic_sql_vars).
        # The `continue` in those main blocks usually prevents this from re-running for the same line.
        if [[ "$trimmed_line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)[^:=]*:=[[:space:]]*\'([^\']*)\'[[:space:]]*(;[[:space:]]*)?$ ]]; then 
            varname_dyn_check="${BASH_REMATCH[1]}"
            # Only update if it's specifically 'v_sql' or if not previously set by the primary var assignment blocks
            # However, the primary blocks already handle this. This just ensures last_v_sql is set if it's a v_sql assignment.
            if [[ "$varname_dyn_check" == "v_sql" ]]; then
                 # Ensure dynamic_sql_vars is also populated if it somehow wasn't (though it should be)
                 if ! [[ -v dynamic_sql_vars[$varname_dyn_check] ]]; then
                    dynamic_sql_vars["$varname_dyn_check"]="${BASH_REMATCH[2]}"
                 fi
                 last_v_sql="${dynamic_sql_vars[$varname_dyn_check]}" # Use the value from dynamic_sql_vars for consistency
            fi
        fi


        if [[ "$normalized_line" =~ ^execute[[:space:]]+immediate[[:space:]]+([a-zA-Z_][a-zA-Z0-9_.]+) ]]; then 
            exec_var="${BASH_REMATCH[1]}"
            sql_to_reverse="${dynamic_sql_vars[$exec_var]}"

            if [[ -n "$sql_to_reverse" ]]; then
                lowercase_sql="$(echo "$sql_to_reverse" | tr '[:upper:]' '[:lower:]')"

                if [[ "$lowercase_sql" =~ ^update[[:space:]]+([a-z0-9_.]+)[[:space:]]+set[[:space:]]+ ]]; then
                    table_upd="${BASH_REMATCH[1]}"
                    echo "-- ⚠️ Revert: Cannot determine previous values for UPDATE on $table_upd (from variable $exec_var)" >> "$rollback_file"
                    echo "-- ORIGINAL EXEC IMMEDIATE: $sql_to_reverse" >> "$rollback_file"
                elif [[ "$lowercase_sql" =~ ^alter[[:space:]]+table[[:space:]]+([a-z0-9_.]+)[[:space:]]+add[[:space:]]+([a-z0-9_.]+) ]]; then
                    table_alt="${BASH_REMATCH[1]}"
                    column_alt="${BASH_REMATCH[2]}"
                    echo "ALTER TABLE $table_alt DROP COLUMN $column_alt;" >> "$rollback_file"
                elif [[ "$lowercase_sql" =~ ^create[[:space:]]+(unique[[:space:]]+)?index[[:space:]]+([a-z0-9_.]+)[[:space:]]+on[[:space:]]+([a-z0-9_.]+).* ]]; then
                    index_name="${BASH_REMATCH[2]}" # Group 2 is the index name
                    echo "DROP INDEX $index_name;" >> "$rollback_file"
                elif [[ "$lowercase_sql" =~ ^alter[[:space:]]+table[[:space:]]+([a-z0-9_.]+)[[:space:]]+modify[[:space:]]*\(.*not[[:space:]]+null.*\) ]]; then
                    table_mod="${BASH_REMATCH[1]}"
                    echo "-- ⚠️ Revert: Consider allowing NULLs again on $table_mod (from variable $exec_var modifying to NOT NULL)" >> "$rollback_file"
                    echo "-- ORIGINAL EXEC IMMEDIATE: $sql_to_reverse" >> "$rollback_file"
                else
                    echo "-- ⚠️ Unrecognized EXECUTE IMMEDIATE rollback from $exec_var: $sql_to_reverse" >> "$rollback_file"
                fi
            else
                echo "-- ⚠️ MANUAL CHECK REQUIRED: EXECUTE IMMEDIATE using unknown or uncaptured variable $exec_var" >> "$rollback_file"
                echo "-- ORIGINAL: $trimmed_line" >> "$rollback_file"
            fi
            continue
        fi

        # Handle DELETE FROM statements
if [[ "$normalized_line" =~ ^delete[[:space:]]+from[[:space:]]+ ]]; then
    echo "-- ⚠️ MANUAL CHECK REQUIRED: This DELETE statement needs careful review for rollback." >> "$rollback_file"
    echo "-- ORIGINAL: $trimmed_line" >> "$rollback_file"
    continue
fi
        
     # INSERT INTO tablename VALUES (...) — fallback to PL/SQL
if [[ "$normalized_line" == insert\ into*values* ]]; then
    table=$(echo "$normalized_line" | sed -nE "s/insert[[:space:]]+into[[:space:]]+([a-z0-9_]+)[[:space:]]+values.*/\1/p")
    raw_values=$(echo "$trimmed_line" | sed -nE "s/.*values[[:space:]]*\(([^)]+)\).*/\1/p")

    if [[ -n "$table" && -n "$raw_values" ]]; then
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
            v_sql := v_sql || 'UPPER(' || col.column_name || ') = UPPER(' || v_val || ')';
        ELSE
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
fi

        # Fallback for unhandled SQL that looks like DDL/DML
        if [[ "$normalized_line" =~ ^(create|drop|alter|merge|truncate|rename)[[:space:]]+ ]]; then
            echo "-- ⚠️ MANUAL CHECK REQUIRED: Unhandled DDL/DML (fallback)" >> "$rollback_file"
            echo "-- ORIGINAL: $trimmed_line" >> "$rollback_file"
            continue
        fi
        if [[ "$normalized_line" =~ ^execute[[:space:]]+immediate && ! "$normalized_line" =~ ^execute[[:space:]]+immediate[[:space:]]+([a-zA-Z_][a-zA-Z0-9_.]+) ]]; then
             echo "-- ⚠️ MANUAL CHECK REQUIRED: Unhandled EXECUTE IMMEDIATE (literal string?)" >> "$rollback_file"
             echo "-- ORIGINAL: $trimmed_line" >> "$rollback_file"
             continue
        fi
    done < "$sql_file"
done

echo "Rollback scripts generated in $OUTPUT_DIR"