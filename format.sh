#!/bin/bash

# --- Configuration ---
# Set your source and destination directories here.
# INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/test"
# FORMATTED_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/test/formatted"

# INPUT_DIR="C:/Users/SBS/Desktop/Oracle-DB-Rollback-automation/input/test"
# FORMATTED_DIR="C:/Users/SBS/Desktop/Oracle-DB-Rollback-automation/input/test/formatted"

INPUT_DIR="C:/Users/SBS/Desktop/Oracle-DB-Rollback-automation/input/test"
FORMATTED_DIR="C:/Users/SBS/Desktop/Oracle-DB-Rollback-automation/input/test/formatted"

# --- Main Logic ---
# Ensure the destination directory exists
mkdir -p "$FORMATTED_DIR"

echo "🚀 Starting SQL formatting process..."
echo "   Input directory: $INPUT_DIR"
echo "   Formatted output directory: $FORMATTED_DIR"

# Check if Perl is available, as it is more robust for this task
if ! command -v perl &> /dev/null
then
    echo "❌ ERROR: 'perl' command could not be found. Please ensure it is installed and in your PATH."
    exit 1
fi

# Loop through all .sql files in the input directory
for sql_file in "$INPUT_DIR"/*.sql; do
    # Check if file exists to prevent errors with empty directories or no matches
    [ -e "$sql_file" ] || continue

    filename=$(basename "$sql_file")
    formatted_file="$FORMATTED_DIR/$filename"

    echo "   📄 Formatting $filename..."

    # Use a Perl one-liner for robust, multi-line aware formatting.
    # This reads the whole file at once.
    perl -0777 -pe '
        s|/\*.*?\*/||sg;                  # 1. Remove multi-line /* ... */ comments
        s/--.*$//mg;                      # 2. Remove single-line -- comments
        s/[\r\n]+/ /g;                     # 3. Replace all newline characters with a single space
        s/[[:space:]]+/ /g;               # 4. Condense all whitespace into single spaces
        s/\s*;\s*/;\n/g;                   # 5. Ensure a newline is placed immediately after every semicolon
        s/(^\s*|\s*$)//g;                 # 6. Trim leading/trailing whitespace from the whole file
        
        # 7. Put critical PL/SQL keywords on their own lines for readability
        s/\b(DECLARE|BEGIN|EXCEPTION|END;|LOOP|IF|THEN|ELSE|ELSIF)\b/\n$1\n/gi;
        
        # 8. Clean up potential blank lines created by the keyword formatting
        s/\n\s*\n/\n/g;
        s/^\n+//;
    ' "$sql_file" > "$formatted_file"

done

echo "✅ Formatting complete. Formatted files are in $FORMATTED_DIR"