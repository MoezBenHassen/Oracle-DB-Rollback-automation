#!/bin/bash

# INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/test"
# OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/test"

# INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/25.2.0.0"
# OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/25.2.0.0/test"

INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/test"
OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/test"

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

        # Pattern for := assignment (PL/SQL-style) - CORRECTED REGEX SUFFIX
        # This regex allows for type declarations between variable name and :=
        # e.g., v_name VARCHAR2(100) := 'value';
        if [[ "$trimmed_line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)[^:=]*:=[[:space:]]*\'([^\']*)\'[[:space:]]*(;[[:space:]]*)?$ ]]; then
            varname="${BASH_REMATCH[1]}"
            varvalue="${BASH_REMATCH[2]}"
            var_map["$varname"]="$varvalue"
            dynamic_sql_vars["$varname"]="$varvalue"
            if [[ "$varname" == "v_sql" ]]; then
                last_v_sql="$varvalue"
            fi
            # echo "DEBUG: PL/SQL var assigned: $varname = $varvalue" >&2 # Optional debug
            continue
        fi

        # Pattern for = assignment (SQL-style, e.g., SQL*Plus DEFINE or similar) - CORRECTED REGEX SUFFIX
        # Adjusted to be similar to the PL/SQL one for consistency
        if [[ "$trimmed_line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)[^=]*=[[:space:]]*\'([^\']*)\'[[:space:]]*(;[[:space:]]*)?$ ]]; then
            varname="${BASH_REMATCH[1]}"
            varvalue="${BASH_REMATCH[2]}"
            # Only populate var_map if it's not a command like "SET DEFINE OFF"
            if ! [[ "$varname" =~ ^(SET|DEFINE|ACCEPT|PROMPT)$ ]]; then # Case-sensitive check, adjust if needed
                 var_map["$varname"]="$varvalue"
                 dynamic_sql_vars["$varname"]="$varvalue"
                 if [[ "$varname" == "v_sql" ]]; then
                     last_v_sql="$varvalue"
                 fi
                 # echo "DEBUG: SQL var assigned: $varname = $varvalue" >&2 # Optional debug
            fi
            continue
        fi

        # INSERT INTO table(col1, col2) VALUES(...)
        regex_insert_with_cols="insert[[:space:]]+into[[:space:]]+([a-z0-9_.]+)[[:space:]]*\(([^)]+)\)[[:space:]]*values[[:space:]]*\(([^)]+)\)"
        if [[ "$normalized_line" =~ $regex_insert_with_cols ]]; then
            table="${BASH_REMATCH[1]}"
            columns_norm="${BASH_REMATCH[2]}" 
            # values_str_norm="${BASH_REMATCH[3]}" # This would be from normalized_line

            # Re-extract values string from trimmed_line to preserve variable casing
            # The regex used for extraction needs to be robust for potentially complex values.
            # This sed extracts content between the first '(' after VALUES and the last ')' on the line.
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
        
        # Fallback INSERT INTO ... VALUES (...) without explicit column list
        if [[ "$normalized_line" =~ insert[[:space:]]+into[[:space:]]+([a-z0-9_.]+)[[:space:]]*values[[:space:]]*\( && ! "$normalized_line" =~ insert[[:space:]]+into[[:space:]]+[a-z0-9_.]+[[:space:]]*\(.*\) ]]; then
            echo "-- ⚠️ MANUAL CHECK REQUIRED for INSERT without explicit columns list (variable substitution might be incomplete):" >> "$rollback_file"
            echo "-- ORIGINAL: $trimmed_line" >> "$rollback_file"
            table="${BASH_REMATCH[1]}"
            values_str_orig_case=$(echo "$trimmed_line" | sed -nE "s/.*[vV][aA][lL][uU][eE][sS][[:space:]]*\((.*)\)[[:space:]]*;?[[:space:]]*$/\1/p")
            IFS=',' read -ra val_array <<< "$values_str_orig_case"
            resolved_values=()
            for raw_val_generic in "${val_array[@]}"; do
                r_val="$(echo "$raw_val_generic" | xargs)"
                if [[ "$r_val" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]] && [[ -v var_map[$r_val] ]]; then
                    resolved_values+=("'${var_map[$r_val]}'")
                elif [[ "$r_val" =~ ^\'.*\'$ || "$r_val" =~ ^[0-9]+(\.[0-9]+)?$ || "$(echo "$r_val" | tr '[:upper:]' '[:lower:]')" == "null" ]]; then
                    resolved_values+=("$r_val")
                else
                    resolved_values+=("'$r_val'") 
                fi
            done
            echo "-- POTENTIAL ROLLBACK (assumes column order and requires verification): DELETE FROM $table WHERE ... values (" "$(IFS=,; echo "${resolved_values[*]}")" ");" >> "$rollback_file"
            continue
        fi


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

        # Track dynamic SQL assigned to any variable (including v_sql) - CORRECTED REGEX SUFFIX
        # This block is for v_sql or other variables used in EXECUTE IMMEDIATE.
        # The main variable assignment blocks above already populate dynamic_sql_vars too.
        # This might be redundant if the first two blocks cover all cases for var_map and dynamic_sql_vars.
        # However, if a line ONLY assigns to a var for EXEC IMMEDIATE and wasn't caught by the := or = for var_map,
        # this could be a fallback. The `continue` in earlier blocks should prevent re-processing.
        # For clarity, ensuring this uses the corrected regex.
        if [[ "$trimmed_line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)[^:=]*:=[[:space:]]*\'([^\']*)\'[[:space:]]*(;[[:space:]]*)?$ ]]; then 
            varname_dyn="${BASH_REMATCH[1]}"
            var_sql="${BASH_REMATCH[2]}"
            dynamic_sql_vars["$varname_dyn"]="$var_sql" # Already populated by main blocks if also for var_map

            if [[ "$varname_dyn" == "v_sql" ]]; then
                last_v_sql="$var_sql"
            fi
            # No 'continue' here, as the main var assignment already did if it matched.
            # If this block is truly separate, it might need its own continue, but structure implies it's mostly covered.
        fi


        if [[ "$normalized_line" =~ ^execute[[:space:]]+immediate[[:space:]]+([a-zA-Z_][a-zA-Z0-9_.]+) ]]; then # Allowed . in var name
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
                    # BASH_REMATCH[1] is "unique " or empty
                    # BASH_REMATCH[2] is index name
                    index_name="${BASH_REMATCH[2]}"
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
        
        # INSERT INTO tablename VALUES (...) — fallback to PL/SQL for inserts without explicit column lists
        if [[ "$normalized_line" =~ insert[[:space:]]+into[[:space:]]+([a-z0-9_.]+)[[:space:]]+values[[:space:]]*\( && ! "$normalized_line" =~ insert[[:space:]]+into[[:space:]]+[a-z0-9_.]+[[:space:]]*\(.*\) ]]; then
            table_fallback=$(echo "$normalized_line" | sed -nE "s/insert[[:space:]]+into[[:space:]]+([a-z0-9_.]+)[[:space:]]+values.*/\1/p")
            raw_values_fallback=$(echo "$trimmed_line" | sed -nE "s/.*[vV][aA][lL][uU][eE][sS][[:space:]]*\((.*)\)[[:space:]]*;?[[:space:]]*$/\1/p")

            if [[ -n "$table_fallback" && -n "$raw_values_fallback" ]]; then
                IFS=',' read -ra val_array_fb <<< "$raw_values_fallback"
                substituted_values_fb=()
                for val_fb_item in "${val_array_fb[@]}"; do
                    processed_val_fb="$(echo "$val_fb_item" | xargs)"
                    if [[ "$processed_val_fb" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]] && [[ -v var_map[$processed_val_fb] ]]; then
                        substituted_values_fb+=("'${var_map[$processed_val_fb]}'")
                    elif [[ "$processed_val_fb" =~ ^\'.*\'$ || "$processed_val_fb" =~ ^[0-9]+(\.[0-9]+)?$ || "$(echo "$processed_val_fb" | tr '[:upper:]' '[:lower:]')" == "null" ]]; then
                        substituted_values_fb+=("$processed_val_fb")
                    else
                        substituted_values_fb+=("'$processed_val_fb'") 
                    fi
                done
                final_values_for_plsql=$(IFS=,; echo "${substituted_values_fb[*]}")
                escaped_values_for_plsql=$(echo "$final_values_for_plsql" | sed "s/'/''/g") 

cat >> "$rollback_file" <<EOF
-- Revert: DELETE from $table_fallback using PL/SQL metadata lookup (values after potential variable substitution)
-- Original values part: ($raw_values_fallback)
-- Substituted values for PL/SQL: ($final_values_for_plsql)
DECLARE
    v_sql_rb CLOB := 'DELETE FROM $table_fallback WHERE ';
    v_vals_rb CLOB := '$escaped_values_for_plsql'; 
    idx_rb PLS_INTEGER := 1;
    v_val_rb VARCHAR2(4000);
    first_rb BOOLEAN := TRUE;
BEGIN
    FOR col_rb IN (
        SELECT column_name, data_type
        FROM all_tab_columns
        WHERE table_name = UPPER('$table_fallback')
          AND owner = SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') 
        ORDER BY column_id
    ) LOOP
        v_val_rb := TRIM(REGEXP_SUBSTR(v_vals_rb, '(''[^'']*''|[^,]+)', 1, idx_rb));
        
        IF v_val_rb IS NULL THEN 
            IF idx_rb > REGEXP_COUNT(v_vals_rb, ',')+1 THEN
                 EXIT; -- No more values, and we are past the last expected value
            ELSE
                 v_val_rb := 'NULL'; -- Explicit NULL in the list
            END IF;
        END IF;

        IF NOT first_rb THEN
            v_sql_rb := v_sql_rb || ' AND ';
        ELSE
            first_rb := FALSE;
        END IF;

        IF UPPER(v_val_rb) = 'NULL' THEN
            v_sql_rb := v_sql_rb || col_rb.column_name || ' IS NULL';
        ELSIF col_rb.data_type LIKE '%CHAR%' OR col_rb.data_type = 'CLOB' OR col_rb.data_type = 'DATE' OR col_rb.data_type LIKE '%TIMESTAMP%' THEN
            v_sql_rb := v_sql_rb || col_rb.column_name || ' = ' || v_val_rb;
        ELSE 
            v_sql_rb := v_sql_rb || col_rb.column_name || ' = ' || v_val_rb;
        END IF;
        idx_rb := idx_rb + 1;
    END LOOP;

    IF first_rb THEN 
        DBMS_OUTPUT.PUT_LINE('-- Rollback for $table_fallback: No conditions generated for DELETE. Manual check needed.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Executing rollback: ' || v_sql_rb);
        EXECUTE IMMEDIATE v_sql_rb;
        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted from $table_fallback.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('-- Error during PL/SQL rollback for $table_fallback: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('-- Generated SQL was: ' || v_sql_rb);
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