#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;
use File::Path qw(make_path);

# --- Configuration ---
my $input_dir  = "C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/test"; # Using non-formatted for this example
my $output_dir = "C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/test/nonformat";

# --- Main Logic ---
# Ensure output directory exists
make_path($output_dir) unless -d $output_dir;

print "🚀 Starting Perl-based rollback generation...\n";
print "   Input directory: $input_dir\n";
print "   Output directory: $output_dir\n";

# Get all .sql files
my @sql_files = glob("$input_dir/*.sql");

die "❌ ERROR: No .sql files found in $input_dir\n" unless @sql_files;

# Loop through all .sql files
for my $sql_file (@sql_files) {
    my $filename = basename($sql_file);
    my $rollback_file = "$output_dir/rollback_$filename";

    print "   📄 Generating rollback for $filename...\n";

    # Open files with UTF-8 encoding to be safe
    open my $in_fh,  '<:encoding(UTF-8)', $sql_file or die "Could not open $sql_file: $!";
    open my $out_fh, '>:encoding(UTF-8)', $rollback_file or die "Could not open $rollback_file: $!";

    print $out_fh "-- 🔁 Rollback of $filename\n";

    # State for the current file: holds values of script variables like v_sql
    my %vars;
    my $current_statement_buffer = ""; # For multi-line statements not ending in ;

    while (my $line = <$in_fh>) {
        chomp $line;
        my $trimmed_line = $line;
        $trimmed_line =~ s/^\s+|\s+$//g; # Trim leading/trailing whitespace for logic
        $trimmed_line =~ s/\s*--.*$//;   # Remove comments for logic
        
        next if $trimmed_line eq ''; # Skip empty lines

        # Accumulate lines into a buffer until a semicolon is found (or / for PL/SQL blocks)
        # This assumes your formatter script might not perfectly put every statement on one line,
        # or you run this on non-formatted files.
        if ($current_statement_buffer eq "") {
            $current_statement_buffer = $line; # Use original line for buffer
        } else {
            $current_statement_buffer .= "\n" . $line; # Preserve newlines in buffer
        }
        
        # Check if the buffered statement is complete
        # Complete if it ends with a semicolon, or is just "/"
        if ( $current_statement_buffer =~ /;\s*$/s || $trimmed_line eq '/' ) {
            my $statement_to_process = $current_statement_buffer;
            $current_statement_buffer = ""; # Reset buffer for next statement

            # Process the complete statement
            my $original_statement_for_output = $statement_to_process; # Keep original for comments
            $original_statement_for_output =~ s/^\s+|\s+$//mg; # Trim for output consistency

            $statement_to_process =~ s/[\r\n]+/ /g; # Flatten to single line for regex
            $statement_to_process =~ s/^\s+|\s+$//g;
            
            my $normalized_statement = lc($statement_to_process);


            ### --- SQL Statement Dispatcher --- ###

            # 1. Variable Assignment: my_var := 'some_value';
            if ($statement_to_process =~ /^\s* ([a-zA-Z_]\w*) \s* .*? := \s* ' ( (?:[^']|'')* ) ' \s* ;? $/x) {
                my ($var_name, $var_value) = ($1, $2);
                $vars{$var_name} = $var_value;
            }

            # 2. INSERT INTO table (cols) VALUES (...) statement
            elsif ($statement_to_process =~ /^insert \s+ into \s+ ([\w.]+) \s* \( \s* ([^)]+) \s* \) \s* values \s* \( \s* (.*) \s* \) \s* ;? $/xi) {
                my ($table, $cols_str, $vals_str) = (lc($1), $2, $3); # Lowercase table

                my @cols = split(/\s*,\s*/, $cols_str);
                my @vals;
                while ($vals_str =~ / (?: ( ' (?:[^']|'')* ' ) | ( [^,]+ ) ) /xg) {
                    push @vals, defined($1) ? $1 : $2;
                }

                my @where_parts;
                if (@cols == @vals) {
                    for my $i (0 .. $#cols) {
                        my $col = lc($cols[$i]); # Lowercase column name
                        my $val = $vals[$i];
                        $col =~ s/^\s+|\s+$//g;
                        $val =~ s/^\s+|\s+$//g;
                        my $final_val = '';

                        if ($val =~ /^'.*'$/ or $val =~ /^-?\d+(\.\d+)?$/ or lc($val) eq 'null') {
                            $final_val = $val;
                        }
                        elsif (exists $vars{$val}) {
                            $final_val = "'" . $vars{$val} . "'";
                        }
                        else { next; }

                        if (lc($final_val) eq 'null' or lc($final_val) eq "'null'") {
                            push @where_parts, "$col IS NULL";
                        } else {
                            push @where_parts, "$col = $final_val";
                        }
                    }
                }

                if (@where_parts) {
                    my $where_clause = join(' AND ', @where_parts);
                    print $out_fh "DELETE FROM $table WHERE $where_clause;\n";
                } else {
                    print $out_fh "-- ⚠️ MANUAL CHECK REQUIRED: Could not generate specific WHERE for INSERT (with cols) on $table.\n";
                    print $out_fh "-- ORIGINAL INSERT: $original_statement_for_output\n";
                }
            }

            # *** NEW HANDLER: INSERT INTO table VALUES (...) ***
            elsif ($statement_to_process =~ /^insert \s+ into \s+ ([\w.]+) \s+ values \s* \( \s* (.*) \s* \) \s* ;? $/xi) {
                my ($table_no_cols, $vals_str_no_cols) = (lc($1), $2); # Lowercase table name for consistency

                my $escaped_vals_for_plsql = $vals_str_no_cols;
                $escaped_vals_for_plsql =~ s/'/''/g; # Escape single quotes for PL/SQL CLOB literal

                print $out_fh <<EOF_PLSQL;
-- Revert: DELETE from $table_no_cols using PL/SQL metadata lookup
-- Note: This block assumes values in the INSERT statement do not contain commas themselves.
DECLARE
    v_sql  CLOB := 'DELETE FROM $table_no_cols WHERE ';
    v_vals CLOB := '$escaped_vals_for_plsql';
    i      PLS_INTEGER := 1;
    v_val  VARCHAR2(4000);
    first  BOOLEAN := TRUE;
    v_table_name VARCHAR2(128) := UPPER('$table_no_cols');
BEGIN
    FOR col IN (
        SELECT column_name, data_type
        FROM all_tab_columns
        WHERE table_name = v_table_name
          AND owner = USER -- Consider if schema might be different or passed as parameter
        ORDER BY column_id
    ) LOOP
        -- This simple REGEXP_SUBSTR will break if values themselves contain commas.
        -- For more complex CSV parsing in PL/SQL, a dedicated function would be needed.
        v_val := TRIM(REGEXP_SUBSTR(v_vals, '[^,]+', 1, i));
        EXIT WHEN v_val IS NULL AND i > 1; -- Exit if no more values (allow first value to be NULL)


        IF NOT first THEN
            v_sql := v_sql || ' AND ';
        ELSE
            first := FALSE;
        END IF;

        IF v_val IS NULL OR UPPER(v_val) = 'NULL' THEN
            v_sql := v_sql || col.column_name || ' IS NULL';
        ELSIF col.data_type LIKE '%CHAR%' OR col.data_type = 'CLOB' THEN
            v_sql := v_sql || 'UPPER(' || col.column_name || ') = UPPER(' || v_val || ')';
        ELSIF col.data_type LIKE '%DATE%' OR col.data_type LIKE '%TIMESTAMP%' THEN
             -- For dates/timestamps, v_val must be a string literal that Oracle can implicitly convert,
             -- or a TO_DATE/TO_TIMESTAMP expression. Example: '01-JAN-2024' or TO_DATE('20240101','YYYYMMDD')
             v_sql := v_sql || col.column_name || ' = ' || v_val;
        ELSE -- For numbers predominantly
            v_sql := v_sql || col.column_name || ' = ' || v_val;
        END IF;
        i := i + 1;
    END LOOP;

    IF first THEN -- No conditions were added
        DBMS_OUTPUT.PUT_LINE('-- Rollback for INSERT INTO ' || v_table_name || ': No conditions generated (e.g., no columns found or only NULL values). Manual check required.');
        -- As a precaution, comment out the EXECUTE IMMEDIATE or make it conditional
        -- EXECUTE IMMEDIATE 'SELECT 1 FROM DUAL'; -- No-op or error
    ELSE
        v_sql := v_sql || ';'; -- Add semicolon to complete the SQL
        DBMS_OUTPUT.PUT_LINE('Generated Rollback SQL: ' || v_sql);
        EXECUTE IMMEDIATE v_sql;
        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' row(s) deleted from ' || v_table_name || '.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('-- Error during rollback of INSERT INTO ' || v_table_name || ': ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('-- Attempted SQL: ' || v_sql);
        RAISE; -- Re-raise the exception to ensure failure is noted
END;
/
EOF_PLSQL
            }
            # *** END OF NEW HANDLER ***

            # 3. ALTER TABLE ADD statement
            elsif ($normalized_statement =~ /^alter \s+ table \s+ ([\w.]+) \s+ add \s+ ([\w.]+) /x) {
                 print $out_fh "ALTER TABLE " . lc($1) . " DROP COLUMN " . lc($2) . ";\n";
            }

            # 4. EXECUTE IMMEDIATE statement
            elsif ($normalized_statement =~ /^execute \s+ immediate \s+ ([\w.]+) /xi) {
                my $exec_var = $1;
                if (exists $vars{$exec_var}) {
                    my $sql_to_reverse = $vars{$exec_var};
                    my $normalized_sql_to_reverse = lc($sql_to_reverse); # Use a different var name

                    if ($normalized_sql_to_reverse =~ /^\s* alter \s+ table \s+ ([\w.]+) \s+ add \s+ ([\w.]+) /x) {
                        print $out_fh "ALTER TABLE " . lc($1) . " DROP COLUMN " . lc($2) . ";\n";
                    }
                    elsif ($normalized_sql_to_reverse =~ /^\s* create \s+ (?:unique\s+)? index \s+ ([\w.]+) /x) {
                        print $out_fh "DROP INDEX " . lc($1) . ";\n";
                    }
                    elsif ($normalized_sql_to_reverse =~ /^\s* update\b/x) {
                         print $out_fh "-- ⚠️ Revert: Cannot determine previous values for UPDATE from variable '$exec_var'\n";
                         print $out_fh "-- ORIGINAL EXEC IMMEDIATE: $sql_to_reverse\n";
                    }
                    else {
                        print $out_fh "-- ⚠️ Unrecognized EXECUTE IMMEDIATE content from variable '$exec_var': $sql_to_reverse\n";
                    }
                } else {
                     print $out_fh "-- ⚠️ MANUAL CHECK REQUIRED: EXECUTE IMMEDIATE using unknown or uncaptured variable '$exec_var'\n";
                     print $out_fh "-- ORIGINAL: $original_statement_for_output\n";
                }
            }

            # 5. UPDATE and DELETE statements (flag for manual review)
            elsif ($normalized_statement =~ /^(update|delete)\b/i) {
                 print $out_fh "-- ⚠️ MANUAL CHECK REQUIRED: $1 statement needs manual rollback.\n";
                 print $out_fh "-- ORIGINAL: $original_statement_for_output\n";
            }

            # 6. Other DDL as a fallback (flag for manual review)
            elsif ($normalized_statement =~ /^(create|drop|truncate|rename)\b/i) {
                print $out_fh "-- ⚠️ MANUAL CHECK REQUIRED: Unhandled DDL statement.\n";
                print $out_fh "-- ORIGINAL: $original_statement_for_output\n";
            }
            # Add an else here to catch statements that fell through all specific handlers
            else {
                # Only print if it's not just PL/SQL structural keywords we already handle
                unless ($original_statement_for_output =~ /^(DECLARE|BEGIN|END|EXCEPTION|IF|THEN|ELSE|ELSIF|LOOP|RETURN|COMMIT|ROLLBACK|SAVEPOINT)/i || $original_statement_for_output =~ /^\/$/) {
                    print $out_fh "-- ❓ UNHANDLED STATEMENT (please review for manual rollback):\n";
                    print $out_fh "-- ORIGINAL: $original_statement_for_output\n";
                }
            }
        } # End if statement_is_complete
    } # End while loop for lines

    # After processing all lines in the file, if there's anything left in the buffer
    # (e.g. file doesn't end with a semicolon)
    if ($current_statement_buffer ne "") {
        my $final_statement_to_process = $current_statement_buffer;
        $final_statement_to_process =~ s/[\r\n]+/ /g;
        $final_statement_to_process =~ s/^\s+|\s+$//g;
        my $original_final_statement = $current_statement_buffer;
        $original_final_statement =~ s/^\s+|\s+$//mg;


        print $out_fh "-- ❓ UNHANDLED TRAILING CONTENT (please review for manual rollback):\n";
        print $out_fh "-- ORIGINAL: $original_final_statement\n";
    }


    close $in_fh;
    close $out_fh;
}

print "✅ Rollback generation complete.\n";