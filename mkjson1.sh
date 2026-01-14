#!/bin/bash

# Check if destination directory is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <destination_directory>"
    echo "Example: $0 /path/to/destination"
    exit 1
fi

DEST_DIR="$1"
JSON_FILE="${DEST_DIR}/file_mapping.json"

# Check if directory exists
if [ ! -d "$DEST_DIR" ]; then
    echo "Error: Directory '$DEST_DIR' does not exist"
    exit 1
fi

# Create JSON file with initial content
echo "{" > "$JSON_FILE"

# Get all files (excluding directories)
FILES=("$DEST_DIR"/*)
FIRST=true

for FILE in "${FILES[@]}"; do
    # Skip if it's a directory or the JSON file itself
    if [ -d "$FILE" ] || [ "$FILE" = "$JSON_FILE" ]; then
        continue
    fi
    
    # Extract just the filename from the path
    FILENAME=$(basename "$FILE")
    
    # Remove extension for the key
    KEY="${FILENAME%.*}"
    
    # Add comma before all entries except the first
    if [ "$FIRST" = true ]; then
        FIRST=false
    else
        echo "," >> "$JSON_FILE"
    fi
    
    # Add the entry
    echo "  \"$KEY\": \"$FILENAME\"" >> "$JSON_FILE"
done

echo "}" >> "$JSON_FILE"

echo "JSON file created at: $JSON_FILE"


# usage 
# ./mkjson1.sh /path/to/your/directory
