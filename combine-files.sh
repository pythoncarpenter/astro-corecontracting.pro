#!/bin/bash

# Set the name of the output file (in the current directory)
output_file="combined_files.txt"

# Get the current directory automatically
repo_root="$PWD"

# Create or empty the output file
> "$output_file"

# Check if any file names were provided as arguments
if [ $# -eq 0 ]; then
  echo "Error: No file names provided."
  echo "Usage: $0 file1.txt file2.txt file3.txt ..."
  exit 1
fi

# Process each file name provided as a command-line argument
for file_pattern in "$@"; do
  # Find files matching the pattern in the current directory and its subdirectories
  find "$repo_root" -name "$file_pattern" -type f -print0 | while IFS= read -r -d $'\0' file; do
    echo "Processing: $file"
    cat "$file" >> "$output_file"
    echo "" >> "$output_file"  # Add an empty line (optional)
  done
done

echo "Combined files into: $repo_root/$output_file"