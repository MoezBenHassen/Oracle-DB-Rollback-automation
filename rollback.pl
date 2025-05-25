#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;
use File::Path qw(make_path);

# --- Configuration ---
# NOTE: This script should run on the files produced by the formatter script.
my $input_dir  = "C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/test/formatted";
my $output_dir = "C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/test/format";

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

    while (my $line = <$in_fh>) {
        chomp $line;
        my $trimmed_line = $line;
        $trimmed_line =~ s/^\s+|\s+$//g;

        next if $trimmed_line eq ''; # Skip empty lines
        my $normalized_line = lc($trimmed_line);

        ### --- SQL Statement Dispatcher --- ###

        # 1. Variable Assignment: my_var := 'some_value';
        # This regex correctly handles '' as an escaped quote inside the string.
        if ($trimmed_line =~ /^\s* ([a-zA-Z_]\w*) \s* .*? := \s* ' ( (?:[^']|'')* ) ' \s* ;? $/x) {
            my ($var_name, $var_value) = ($1, $2);
            $vars{$var_name} = $var_value;
            next;
        }

        # 2. INSERT INTO statement
        elsif ($normalized_line =~ /^insert \s+ into \s+ ([\w.]+) \s* \( \s* ([^)]+) \s* \) \s* values \s* \( \s* (.*) \s* \) \s* ;? $/x) {
            my ($table, $cols_str, $vals_str) = ($1, $2, $3);

            my @cols = split(/\s*,\s*/, $cols_str);
            # Robustly split CSV-like values string, respecting quotes
            my @vals;
            while ($vals_str =~ / (?: ( ' (?:[^']|'')* ' ) | ( [^,]+ ) ) /xg) {
                push @vals, defined($1) ? $1 : $2;
            }

            # Trim whitespace from all extracted columns and values
            for my $col (@cols) { $col =~ s/^\s+|\s+$//g; }
            for my $val (@vals) { $val =~ s/^\s+|\s+$//g; }

            my @where_parts;
            if (@cols == @vals) {
                for my $i (0 .. $#cols) {
                    my ($col, $val) = ($cols[$i], $vals[$i]);
                    my $final_val = '';

                    # A) Check if value is a literal (quoted string, number, or NULL)
                    if ($val =~ /^'.*'$/ or $val =~ /^-?\d+(\.\d+)?$/ or lc($val) eq 'null') {
                        $final_val = $val;
                    }
                    # B) Check if it's a script variable we have captured
                    elsif (exists $vars{$val}) {
                        $final_val = "'" . $vars{$val} . "'"; # Use stored value, wrap in quotes
                    }
                    # C) Otherwise, skip it (it's a runtime variable like v_next_val or a function like SYSDATE)
                    else {
                        next; # Skip this column/value pair
                    }

                    # Add the condition to the WHERE clause
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
                print $out_fh "-- ⚠️ MANUAL CHECK REQUIRED: Could not generate a specific WHERE clause for INSERT on $table.\n";
                print $out_fh "-- ORIGINAL INSERT: $trimmed_line\n";
            }
            next;
        }

        # 3. ALTER TABLE ADD statement
        elsif ($normalized_line =~ /^alter \s+ table \s+ ([\w.]+) \s+ add \s+ ([\w.]+) /x) {
             print $out_fh "ALTER TABLE $1 DROP COLUMN $2;\n";
             next;
        }

        # 4. EXECUTE IMMEDIATE statement
        elsif ($normalized_line =~ /^execute \s+ immediate \s+ ([\w.]+) /xi) {
            my $exec_var = $1;
            if (exists $vars{$exec_var}) {
                my $sql_to_reverse = $vars{$exec_var};
                my $normalized_sql = lc($sql_to_reverse);

                # Check the content of the variable for known DDL patterns
                if ($normalized_sql =~ /^\s* alter \s+ table \s+ ([\w.]+) \s+ add \s+ ([\w.]+) /x) {
                    print $out_fh "ALTER TABLE $1 DROP COLUMN $2;\n";
                }
                elsif ($normalized_sql =~ /^\s* create \s+ (?:unique\s+)? index \s+ ([\w.]+) /x) {
                    print $out_fh "DROP INDEX $1;\n";
                }
                elsif ($normalized_sql =~ /^\s* update\b/x) {
                     print $out_fh "-- ⚠️ Revert: Cannot determine previous values for UPDATE from variable '$exec_var'\n";
                     print $out_fh "-- ORIGINAL EXEC IMMEDIATE: $sql_to_reverse\n";
                }
                else {
                    print $out_fh "-- ⚠️ Unrecognized EXECUTE IMMEDIATE content from variable '$exec_var': $sql_to_reverse\n";
                }
            } else {
                 print $out_fh "-- ⚠️ MANUAL CHECK REQUIRED: EXECUTE IMMEDIATE using unknown or uncaptured variable '$exec_var'\n";
                 print $out_fh "-- ORIGINAL: $trimmed_line\n";
            }
            next;
        }

        # 5. UPDATE and DELETE statements (flag for manual review)
        elsif ($normalized_line =~ /^(update|delete)\b/i) {
             print $out_fh "-- ⚠️ MANUAL CHECK REQUIRED: $1 statement needs manual rollback.\n";
             print $out_fh "-- ORIGINAL: $trimmed_line\n";
             next;
        }

        # 6. Other DDL as a fallback (flag for manual review)
        elsif ($normalized_line =~ /^(create|drop|truncate|rename)\b/i) {
            print $out_fh "-- ⚠️ MANUAL CHECK REQUIRED: Unhandled DDL statement.\n";
            print $out_fh "-- ORIGINAL: $trimmed_line\n";
            next;
        }
    }

    close $in_fh;
    close $out_fh;
}

print "✅ Rollback generation complete.\n";