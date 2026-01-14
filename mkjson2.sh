#!/bin/bash

# Check if destination directory is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <destination_directory>"
    echo "Example: echo 'meme1.png' | $0 /path/to/destination"
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

FIRST=true

# Read file names from stdin
while IFS= read -r FILENAME; do
    # Skip empty lines
    if [ -z "$FILENAME" ]; then
        continue
    fi
    
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
# Method 1: Pipe filenames
## echo -e "meme1.png\nmeme2.jpg\ndocument.pdf" | ./mkjson2.sh /path/to/directory

# Method 2: Read from file
## cat filelist.txt | ./mkjson2.sh /path/to/directory

# Method 3: Use find command
## find /path/to/files -name "*.png" -type f | xargs basename -a | ./mkjson2.sh /path/to/directory
