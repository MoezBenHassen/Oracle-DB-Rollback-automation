#!/bin/bash

# --- Configuration ---
# Set your source and destination directories here.
INPUT_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/test"
FORMATTED_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/input/test/formatted"

# FORMATTED_DIR="C:/Users/mbenhassen_tr/Desktop/sqlDirectory/output/test/format"


# --- Main Logic ---
# Ensure the destination directory exists
mkdir -p "$FORMATTED_DIR"

echo "🚀 Starting SQL formatting process..."
echo "   Input directory: $INPUT_DIR"
echo "   Formatted output directory: $FORMATTED_DIR"

# Check if awk is available
if ! command -v awk &> /dev/null
then
    echo "❌ ERROR: 'awk' command could not be found. Please ensure it is installed and in your PATH."
    exit 1
fi

# Loop through all .sql files in the input directory
for sql_file in "$INPUT_DIR"/*.sql; do
    # Check if file exists to prevent errors with empty directories or no matches
    [ -e "$sql_file" ] || continue

    filename=$(basename "$sql_file")
    formatted_file="$FORMATTED_DIR/$filename"

    echo "   📄 Formatting $filename..."

    # Use awk for the core formatting logic.
    # This script joins lines until a statement terminator (;) is found,
    # effectively making multi-line statements into single-line statements.
    awk '
    # Function to process and print the contents of the buffer
    function flush_buffer() {
        if (buffer != "") {
            # Remove leading/trailing whitespace and newlines from the entire buffer
            gsub(/^[ \t\n]+|[ \t\n]+$/, "", buffer);
            # Replace any sequence of internal newlines/tabs/spaces with a single space
            gsub(/[ \t\n]+/, " ", buffer);
            print buffer;
            buffer = "";
        }
    }

    # This block runs for every line in the input file
    {
        # Skip empty lines right away
        if ($0 ~ /^[ \t]*$/) {
            next;
        }

        # Preserve critical PL/SQL keywords on their own lines and flush any preceding statement
        if ($0 ~ /^[ \t]*(DECLARE|BEGIN|END|EXCEPTION|IF|THEN|ELSE|ELSIF|LOOP|RETURN|COMMIT)[ \t]*($|;)/i || $0 ~ /^[ \t]*\/[ \t]*$/) {
            flush_buffer();
            print $0;
            next;
        }

        # Remove trailing single-line comments (-- ...)
        sub(/[ \t]*--.*$/, "");

        # Append the cleaned line to the buffer.
        # Add a space separator unless the buffer is currently empty.
        if (buffer == "") {
            buffer = $0;
        } else {
            buffer = buffer " " $0;
        }

        # If the buffered content now ends with a semicolon, the statement is complete.
        # Process and flush the buffer.
        if (buffer ~ /;[ \t]*$/) {
            flush_buffer();
        }
    }

    # This block runs after all lines have been processed
    END {
        # Flush any remaining content in the buffer (e.g., if the file
        # does not end with a semicolon or block terminator)
        flush_buffer();
    }
    ' "$sql_file" > "$formatted_file"

done

echo "✅ Formatting complete. Formatted files are in $FORMATTED_DIR"