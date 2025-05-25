#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;
use File::Path qw(make_path);

# --- Configuration ---
my $input_dir  = "C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/test";
my $output_dir = "C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/test/nonformat";

# --- Main Logic ---
make_path($output_dir) unless -d $output_dir;

print "🚀 Starting Perl-based rollback generation...\n";
print "   Input directory: $input_dir\n";
print "   Output directory: $output_dir\n";

my @sql_files = glob("$input_dir/*.sql");
die "❌ ERROR: No .sql files found in $input_dir\n" unless @sql_files;

for my $sql_file (@sql_files) {
    my $filename = basename($sql_file);
    my $rollback_file = "$output_dir/rollback_$filename";

    print "   📄 Generating rollback for $filename...\n";

    open my $in_fh,  '<:encoding(UTF-8)', $sql_file or die "Could not open $sql_file: $!";
    open my $out_fh, '>:encoding(UTF-8)', $rollback_file or die "Could not open $rollback_file: $!";

    print $out_fh "-- 🔁 Rollback of $filename\n";

    my %vars;
    my $current_statement_buffer = "";

    while (my $line = <$in_fh>) {
        chomp $line;
        my $original_line_for_buffer = $line;
        
        my $line_for_logic = $line;
        $line_for_logic =~ s/\s*--.*$//;
        $line_for_logic =~ s/^\s+|\s+$//g;
        
        next if $line_for_logic eq '';

        if ($current_statement_buffer eq "") {
            $current_statement_buffer = $original_line_for_buffer;
        } else {
            $current_statement_buffer .= "\n" . $original_line_for_buffer;
        }
        
        if ( $line_for_logic =~ /;\s*$/ || $line_for_logic eq '/' ) {
            my $original_statement_for_output = $current_statement_buffer;
            $current_statement_buffer = "";

            my $statement_to_process_flat = $original_statement_for_output;
            $statement_to_process_flat =~ s/\s*--.*$//mg;
            $statement_to_process_flat =~ s/[\r\n]+/ /g;
            $statement_to_process_flat =~ s/^\s+|\s+$//g;
            
            my $clean_original_for_print = $original_statement_for_output;
            $clean_original_for_print =~ s/^\s+//mg;
            $clean_original_for_print =~ s/\s+$//mg;
            
            my $normalized_statement_for_match = lc($statement_to_process_flat); # Use this for general matching
            my $handled_this_statement = 0;

            ### --- SQL Statement Dispatcher --- ###

            # 1. Variable Assignment: my_var := 'string_value';
            #    Stores variable name as lowercase for consistent lookup.
            if ($statement_to_process_flat =~ /^\s* ([a-zA-Z_]\w*) \s* [^:=]*? := \s* ' ( (?:[^']|'')* ) ' \s* ;? $/xi) {
                my ($var_name_orig_case, $var_value) = ($1, $2);
                my $var_name_lc = lc($var_name_orig_case);
                $vars{$var_name_lc} = $var_value;
                # print $out_fh "-- DEBUG: Stored var: $var_name_lc = $var_value\n"; # Optional debug
                $handled_this_statement = 1;
            }
            # 2. INSERT INTO table (cols) VALUES (...)
            elsif ($statement_to_process_flat =~ /^insert \s+ into \s+ ([\w.]+) \s* \( \s* ([^)]+) \s* \) \s* values \s* \( \s* (.*) \s* \) \s* ;? $/xi) {
                my ($table, $cols_str, $vals_str) = (lc($1), $2, $3);
                my @cols = split(/\s*,\s*/, $cols_str);
                my @vals;
                while ($vals_str =~ / (?: ( ' (?:[^']|'')* ' ) | ( [^,]+ ) ) /xg) {
                    push @vals, defined($1) ? $1 : $2;
                }
                my @where_parts;
                if (@cols == @vals) {
                    for my $i (0 .. $#cols) {
                        my $col = lc($cols[$i]); my $val_token = $vals[$i]; # $val_token is how it appears in VALUES()
                        $col =~ s/^\s+|\s+$//g; $val_token =~ s/^\s+|\s+$//g;
                        my $final_val_for_sql = '';

                        if ($val_token =~ /^'.*'$/ or $val_token =~ /^-?\d+(\.\d+)?$/ or lc($val_token) eq 'null') { # Literal
                            $final_val_for_sql = $val_token;
                        }
                        elsif (exists $vars{lc($val_token)}) { # Script variable (lookup with lowercase)
                            $final_val_for_sql = "'" . $vars{lc($val_token)} . "'"; 
                        }
                        else { next; } # Runtime variable, skip
                        
                        if (lc($final_val_for_sql) eq 'null' or lc($final_val_for_sql) eq "'null'") { push @where_parts, "$col IS NULL"; }
                        else { push @where_parts, "$col = $final_val_for_sql"; }
                    }
                }
                if (@where_parts) { print $out_fh "DELETE FROM $table WHERE " . join(' AND ', @where_parts) . ";\n"; }
                else {
                    print $out_fh "-- ⚠️ MANUAL CHECK REQUIRED: Could not generate specific WHERE for INSERT (with cols) on $table.\n";
                    print $out_fh "-- ORIGINAL INSERT:\n";
                    my @orig_lines = split(/\n/, $clean_original_for_print);
                    foreach my $orig_line (@orig_lines) { print $out_fh "-- $orig_line\n"; }
                }
                $handled_this_statement = 1;
            }
            # 3. INSERT INTO table VALUES (...)
            elsif ($statement_to_process_flat =~ /^insert \s+ into \s+ ([\w.]+) \s+ values \s* \( \s* (.*) \s* \) \s* ;? $/xi) {
                my ($table_no_cols, $vals_str_no_cols) = (lc($1), $2);
                my $escaped_vals_for_plsql = $vals_str_no_cols;
                $escaped_vals_for_plsql =~ s/'/''/g;
                print $out_fh <<EOF_PLSQL;
-- Revert: DELETE from $table_no_cols using PL/SQL metadata lookup
-- Note: This block's REGEXP_SUBSTR assumes values in the INSERT do not contain commas.
DECLARE
    v_sql  CLOB := 'DELETE FROM $table_no_cols WHERE ';
    v_vals CLOB := '$escaped_vals_for_plsql';
    i      PLS_INTEGER := 1;
    v_val  VARCHAR2(4000);
    first  BOOLEAN := TRUE;
    v_table_name VARCHAR2(128) := UPPER('$table_no_cols');
BEGIN
    FOR col IN (
        SELECT column_name, data_type FROM all_tab_columns
        WHERE table_name = v_table_name AND owner = USER ORDER BY column_id
    ) LOOP
        v_val := TRIM(REGEXP_SUBSTR(v_vals, '[^,]+', 1, i));
        EXIT WHEN v_val IS NULL AND i > 1;
        IF NOT first THEN v_sql := v_sql || ' AND '; ELSE first := FALSE; END IF;
        IF v_val IS NULL OR UPPER(v_val) = 'NULL' THEN v_sql := v_sql || col.column_name || ' IS NULL';
        ELSIF col.data_type LIKE '%CHAR%' OR col.data_type = 'CLOB' THEN v_sql := v_sql || 'UPPER(' || col.column_name || ') = UPPER(' || v_val || ')';
        ELSIF col.data_type LIKE '%DATE%' OR col.data_type LIKE '%TIMESTAMP%' THEN v_sql := v_sql || col.column_name || ' = ' || v_val;
        ELSE v_sql := v_sql || col.column_name || ' = ' || v_val; END IF;
        i := i + 1;
    END LOOP;
    IF first THEN DBMS_OUTPUT.PUT_LINE('-- Rollback for INSERT INTO ' || v_table_name || ': No conditions generated. Manual check required.');
    ELSE
        v_sql := v_sql || ';'; DBMS_OUTPUT.PUT_LINE('Generated Rollback SQL: ' || v_sql);
        EXECUTE IMMEDIATE v_sql; DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' row(s) deleted from ' || v_table_name || '.');
    END IF;
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('-- Error during rollback of INSERT INTO ' || v_table_name || ': ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE('-- Attempted SQL: ' || v_sql); RAISE;
END;
/
EOF_PLSQL
                $handled_this_statement = 1;
            }
            # 4. ALTER TABLE ADD statement (direct)
            elsif ($normalized_statement_for_match =~ /^alter \s+ table \s+ ([\w.]+) \s+ add \s+ ([\w.]+) /x) {
                print $out_fh "ALTER TABLE " . lc($1) . " DROP COLUMN " . lc($2) . ";\n";
                $handled_this_statement = 1;
            }
            # 5. EXECUTE IMMEDIATE statement
            elsif ($statement_to_process_flat =~ /^execute \s+ immediate \s+ ([\w.]+) /xi) {
                my $exec_var_orig_case = $1;
                my $exec_var_lc = lc($exec_var_orig_case);

                if (exists $vars{$exec_var_lc}) {
                    my $sql_to_reverse = $vars{$exec_var_lc};
                    my $normalized_sql_to_reverse = lc($sql_to_reverse);
                    if ($normalized_sql_to_reverse =~ /^\s* alter \s+ table \s+ ([\w.]+) \s+ add \s+ ([\w.]+) /x) {
                        print $out_fh "ALTER TABLE " . lc($1) . " DROP COLUMN " . lc($2) . ";\n";
                    } 
                    elsif ($normalized_sql_to_reverse =~ /^\s* alter \s+ table \s+ ([\w.]+) \s+ modify \s* \( .*? not \s+ null .*? \) /x) { # Non-greedy match for content in parens
                        print $out_fh "-- ⚠️ Revert: Consider allowing NULLs again on table " . lc($1) . " (from variable '$exec_var_orig_case' modifying to NOT NULL)\n";
                        print $out_fh "-- ORIGINAL EXEC IMMEDIATE: $sql_to_reverse\n";
                    }
                    elsif ($normalized_sql_to_reverse =~ /^\s* create \s+ (?:unique\s+)? index \s+ ([\w.]+) /x) {
                        print $out_fh "DROP INDEX " . lc($1) . ";\n";
                    } 
                    elsif ($normalized_sql_to_reverse =~ /^\s* update\b/x) {
                        print $out_fh "-- ⚠️ Revert: Cannot determine previous values for UPDATE from variable '$exec_var_orig_case'\n";
                        print $out_fh "-- ORIGINAL EXEC IMMEDIATE: $sql_to_reverse\n";
                    } else {
                        print $out_fh "-- ⚠️ Unrecognized EXECUTE IMMEDIATE content from variable '$exec_var_orig_case': $sql_to_reverse\n";
                    }
                } else {
                    print $out_fh "-- ⚠️ MANUAL CHECK REQUIRED: EXECUTE IMMEDIATE using unknown or uncaptured variable '$exec_var_orig_case'\n";
                    print $out_fh "-- ORIGINAL:\n";
                    my @orig_lines = split(/\n/, $clean_original_for_print);
                    foreach my $orig_line (@orig_lines) { print $out_fh "-- $orig_line\n"; }
                }
                $handled_this_statement = 1;
            }
            # 6. UPDATE statements
            elsif ($normalized_statement_for_match =~ /^(update)\b/i) {
                my $dml_type = ucfirst($1); 
                print $out_fh "-- ⚠️ MANUAL CHECK REQUIRED: $dml_type statement needs manual rollback.\n";
                print $out_fh "-- ORIGINAL:\n";
                my @orig_lines = split(/\n/, $clean_original_for_print);
                foreach my $orig_line (@orig_lines) { print $out_fh "-- $orig_line\n"; }
                $handled_this_statement = 1;
            }
            # 7. DELETE statements
             elsif ($normalized_statement_for_match =~ /^(delete)\b/i) {
                my $dml_type = ucfirst($1); 
                print $out_fh "-- ⚠️ MANUAL CHECK REQUIRED: $dml_type statement needs manual rollback.\n";
                print $out_fh "-- ORIGINAL:\n";
                my @orig_lines = split(/\n/, $clean_original_for_print);
                foreach my $orig_line (@orig_lines) { print $out_fh "-- $orig_line\n"; }
                $handled_this_statement = 1;
            }
            # 8. Other DDL (CREATE, DROP, etc.)
            elsif ($normalized_statement_for_match =~ /^(create|drop|truncate|rename)\b/i) {
                my $ddl_type = ucfirst($1);
                print $out_fh "-- ⚠️ MANUAL CHECK REQUIRED: Unhandled DDL statement ($ddl_type).\n";
                print $out_fh "-- ORIGINAL:\n";
                my @orig_lines = split(/\n/, $clean_original_for_print);
                foreach my $orig_line (@orig_lines) { print $out_fh "-- $orig_line\n"; }
                $handled_this_statement = 1;
            }

            # Fallback for statements not caught above
            if (!$handled_this_statement) {
                my $is_ignorable_plsql = 0;
                if (
                    # Variable declarations: var TYPE; var TYPE := non_string_literal_expr;
                    $statement_to_process_flat =~ /^\s*[a-zA-Z_]\w*\s+[a-zA-Z_][\w\s\(\),.%']*(?:\s*NOT\s+NULL)?(?:\s*:=\s*[^'].*)?;\s*$/i ||
                    # Non-string literal assignments: var := expression;
                    $statement_to_process_flat =~ /^\s*[a-zA-Z_]\w*\s*:=\s*(?!')(?:[^;']|'(?!')(?=') )*;\s*$/i || 
                    # Procedure calls: package.proc(args); proc(args); dbms_output.put_line(...);
                    $statement_to_process_flat =~ /^\s*(?:[a-zA-Z_]\w*\.)*[a-zA-Z_]\w*\s*\( [^)]* \)\s*;\s*$/xi || # Note: \([^)]*\) might be too simple for nested calls
                    # PL/SQL structural keywords
                    $statement_to_process_flat =~ /^(DECLARE|BEGIN|END|EXCEPTION|IF|THEN|ELSE|ELSIF|LOOP|FOR|WHILE|RETURN|COMMIT|ROLLBACK|SAVEPOINT|NULL|EXIT|CONTINUE|CLOSE|OPEN|FETCH|GOTO)/i ||
                    $statement_to_process_flat =~ /^\/\s*$/ 
                ) {
                    $is_ignorable_plsql = 1;
                }

                unless ($is_ignorable_plsql) {
                    print $out_fh "-- ❓ UNHANDLED STATEMENT (please review for manual rollback):\n";
                    print $out_fh "-- ORIGINAL:\n";
                    my @orig_lines = split(/\n/, $clean_original_for_print);
                    foreach my $orig_line (@orig_lines) { print $out_fh "-- $orig_line\n"; }
                }
            }
        } 
    } 

    if ($current_statement_buffer ne "") {
        my $original_final_statement = $current_statement_buffer;
        $original_final_statement =~ s/^\s+//mg; $original_final_statement =~ s/\s+$//mg;

        print $out_fh "-- ❓ UNHANDLED TRAILING CONTENT (please review for manual rollback):\n";
        print $out_fh "-- ORIGINAL:\n";
        my @buffer_lines = split(/\n/, $original_final_statement);
        foreach my $buf_line (@buffer_lines){
            print $out_fh "-- $buf_line\n";
        }
    }

    close $in_fh;
    close $out_fh;
}

print "✅ Rollback generation complete.\n";