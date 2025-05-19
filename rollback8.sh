#!/bin/bash

# INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/25.2.0.0"
# OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/25.2.0.0"


INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/15.14.0.0"
OUTPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/15.14.0.0"


mkdir -p "$OUTPUT_DIR"

for sql_file in "$INPUT_DIR"/*.sql; do
    filename=$(basename "$sql_file")
    rollback_file="$OUTPUT_DIR/rollback_$filename"

    echo "Generating rollback for $filename"
    echo "-- 🔁 Rollback of $filename" > "$rollback_file"

    declare -A var_map

    while IFS= read -r line; do
        trimmed_line="$(echo "$line" | sed 's/^[[:space:]]*//')"
        normalized_line="$(echo "$trimmed_line" | tr '[:upper:]' '[:lower:]')"

        # Variable assignment
        if [[ "$trimmed_line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)[^:]*:=\ *\'([^\']*)\' ]]; then
            var_map["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
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

# Catch any UPDATE statement (direct or EXECUTE IMMEDIATE) and output as manual-check comment
if [[ "$normalized_line" =~ update[[:space:]]+[a-z0-9_]+[[:space:]]+set[[:space:]]+ ]]; then
    echo "-- ⚠️ MANUAL CHECK REQUIRED: the following UPDATE needs to be manually rolledback" >> "$rollback_file"
    echo "-- ORIGINAL: $trimmed_line" >> "$rollback_file"
    continue
fi

# Track dynamic SQL assigned to v_sql
if [[ "$trimmed_line" =~ ^v_sql[[:space:]]*:=[[:space:]]*\'(.*)\' ]]; then
    last_v_sql="${BASH_REMATCH[1]}"
    last_v_sql="${last_v_sql%;}"  # trim trailing semicolon if any
    continue
fi


# When EXECUTE IMMEDIATE v_sql is found, try to reverse the last_v_sql
if [[ "$normalized_line" =~ ^execute[[:space:]]+immediate[[:space:]]+v_sql ]]; then
    lowercase_sql="$(echo "$last_v_sql" | tr '[:upper:]' '[:lower:]')"

    if [[ "$lowercase_sql" =~ ^alter[[:space:]]+table[[:space:]]+([a-z0-9_]+)[[:space:]]+add[[:space:]]+([a-z0-9_]+)[[:space:]]+.*$ ]]; then
        table="${BASH_REMATCH[1]}"
        column="${BASH_REMATCH[2]}"
        echo "ALTER TABLE $table DROP COLUMN $column;" >> "$rollback_file"
    elif [[ "$lowercase_sql" =~ ^update[[:space:]]+([a-z0-9_]+)[[:space:]]+set[[:space:]]+.*$ ]]; then
        echo "-- ⚠️ Revert: Cannot determine previous values for UPDATE: $last_v_sql" >> "$rollback_file"
    elif [[ "$lowercase_sql" =~ ^create[[:space:]]+index[[:space:]]+([a-z0-9_]+)[[:space:]]+on[[:space:]]+([a-z0-9_]+).* ]]; then
        index="${BASH_REMATCH[1]}"
        echo "DROP INDEX $index;" >> "$rollback_file"
    elif [[ "$lowercase_sql" =~ ^alter[[:space:]]+table[[:space:]]+([a-z0-9_]+)[[:space:]]+modify[[:space:]]*\(.*not[[:space:]]+null.*\) ]]; then
        table="${BASH_REMATCH[1]}"
        echo "-- ⚠️ Revert: Consider allowing NULLs again on $table; manual adjustment may be needed" >> "$rollback_file"
    elif [[ -n "$last_v_sql" ]]; then
        echo "-- ⚠️ Unrecognized EXECUTE IMMEDIATE rollback: $last_v_sql" >> "$rollback_file"
    fi

    last_v_sql=""
    continue
fi


        # INSERT INTO tablename (col1, col2) VALUES (...)
 # INSERT INTO with explicit columns
# INSERT INTO table(col1, col2) VALUES(...)
regex_insert="insert[[:space:]]+into[[:space:]]+([a-z0-9_.]+)[[:space:]]*\\(([^)]+)\\)[[:space:]]*values"
if [[ "$normalized_line" =~ $regex_insert ]]; then
    table="${BASH_REMATCH[1]}"
    columns="${BASH_REMATCH[2]}"
    values=$(echo "$trimmed_line" | sed -nE "s/.*values[[:space:]]*\\(([^)]+)\\).*/\1/p")

    if [[ -n "$columns" && -n "$values" ]]; then
        # proceed with building rollback...

        IFS=',' read -ra col_array <<< "$columns"
        IFS=',' read -ra val_array <<< "$values"

        if [[ ${#col_array[@]} -eq ${#val_array[@]} ]]; then
            where_clause=""
            for i in "${!col_array[@]}"; do
                col="$(echo "${col_array[$i]}" | xargs)"
                raw_val="$(echo "${val_array[$i]}" | xargs)"
                if [[ "$raw_val" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ && -n "${var_map[$raw_val]}" ]]; then
                    val="'${var_map[$raw_val]}'"
                else
                    [[ "$raw_val" =~ ^\'.*\'$ ]] && val="$raw_val" || val="'$raw_val'"
                fi
                [[ "$val" =~ ^null$|^NULL$ ]] && where_clause+="$col IS NULL AND " || where_clause+="$col = $val AND "
            done
            where_clause="${where_clause%AND }"
            echo "DELETE FROM $table WHERE $where_clause;" >> "$rollback_file"
        fi
        continue
    fi
fi


# INSERT INTO (...) VALUES (...) with variables that need resolving
if [[ "$normalized_line" =~ insert[[:space:]]+into[[:space:]]+([a-z0-9_]+).*values.* ]]; then
    table="${BASH_REMATCH[1]}"
    columns=$(echo "$trimmed_line" | sed -nE "s/.*INTO[[:space:]]+$table[[:space:]]*\(([^)]+)\)[[:space:]]*VALUES.*/\1/p")
    values=$(echo "$trimmed_line" | sed -nE "s/.*VALUES[[:space:]]*\(([^)]+)\).*/\1/p")

    # Only handle if values contain variable names that exist in var_map
    if [[ -n "$columns" && -n "$values" ]]; then
        IFS=',' read -ra col_array <<< "$columns"
        IFS=',' read -ra val_array <<< "$values"

        needs_resolution=false
        for val in "${val_array[@]}"; do
            cleaned_val="$(echo "$val" | xargs)"
            if [[ "$cleaned_val" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ && -n "${var_map[$cleaned_val]}" ]]; then
                needs_resolution=true
                break
            fi
        done

        if $needs_resolution; then
            if [[ ${#col_array[@]} -eq ${#val_array[@]} ]]; then
                where_clause=""
                for i in "${!col_array[@]}"; do
                    col="$(echo "${col_array[$i]}" | xargs)"
                    raw_val="$(echo "${val_array[$i]}" | xargs)"

                    if [[ "$raw_val" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ && -n "${var_map[$raw_val]}" ]]; then
                        val="'${var_map[$raw_val]}'"
                    else
                        if [[ "$raw_val" =~ ^\'.*\'$ ]]; then
                            val="$raw_val"
                        else
                            val="'$raw_val'"
                        fi
                    fi

                    [[ "$val" =~ ^null$|^NULL$ ]] && where_clause+="$col IS NULL AND " || where_clause+="$col = $val AND "
                done
                where_clause="${where_clause%AND }"
                echo "DELETE FROM $table WHERE $where_clause;" >> "$rollback_file"
                continue
            fi
        fi
    fi
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

# Fallback for unhandled SQL that looks like DDL/DML and is not caught above
if [[ "$normalized_line" =~ ^(create|drop|alter|update|merge|truncate|rename|execute[[:space:]]+immediate) ]]; then
    echo "-- ⚠️ MANUAL CHECK REQUIRED: CASE NOT HANDLED" >> "$rollback_file"
    echo "-- ORIGINAL: $trimmed_line" >> "$rollback_file"
    continue
fi

    done < "$sql_file"
done

echo "Rollback scripts generated in $OUTPUT_DIR"
