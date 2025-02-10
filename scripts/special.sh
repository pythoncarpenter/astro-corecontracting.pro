#!/bin/bash

# --- Configuration ---
SOURCE_DIR="/Users/mitchmcquoid/z9b-projects/business_proj/astro-corecontracting.pro"
DEST_DIR="/Users/mitchmcquoid/z9b-projects/business_proj/new-astro"  # **Change this to your new-astro directory**
ERROR_LOG_FILE="$DEST_DIR/build_errors.log"

# --- Functions ---

# Function to analyze the tree and return a prioritized list of files
analyze_tree() {
  local source_dir="$1"
  local -a files_array

  # Find all relevant files, excluding node_modules and .astro
  while IFS= read -r -d $'\0' file; do
    files_array+=("$file")
  done < <(find "$source_dir" \( -name "node_modules" -o -name ".astro" -o -name ".git" -o -name "dist" \) -prune -o -type f \( -name "*.astro" -o -name "*.js" -o -name "*.mjs" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.json" -o -name "*.css" \) -print0)

  # Prioritize files (you can customize this logic further)
  # We'll use a temporary file to store and sort the prioritized list
  temp_file=$(mktemp)

  for file in "${files_array[@]}"; do
    case "$file" in
      "$SOURCE_DIR/astro.config.mjs"|"$SOURCE_DIR/package.json"|"$SOURCE_DIR/tsconfig.json")
        echo "1 $file" >> "$temp_file"
        ;;
      "$SOURCE_DIR/src/layouts/"*|"$SOURCE_DIR/src/components/"*)
        if [[ "$file" != *"/SchemeToggle.astro" ]]; then
          echo "2 $file" >> "$temp_file"
        fi
        ;;
      "$SOURCE_DIR/src/pages/"*)
        echo "3 $file" >> "$temp_file"
        ;;
      "$SOURCE_DIR/src/lib/"*)
        echo "4 $file" >> "$temp_file"
        ;;
      "$SOURCE_DIR/src/pages/api/"*)
        echo "5 $file" >> "$temp_file"
        ;;
      *)
        echo "6 $file" >> "$temp_file"
        ;;
    esac
  done

  # Sort the files by priority and return the sorted list
  sort -n "$temp_file" | cut -d' ' -f2-

  # Clean up the temporary file
  rm "$temp_file"
}

# Function to copy a file and handle directory creation
copy_file() {
  local source_file="$1"
  local dest_file="$2"

  # Create the parent directory in the destination if it doesn't exist
  mkdir -p "$(dirname "$dest_file")"

  # Copy the file
  cp "$source_file" "$dest_file"

  echo "Copied: $source_file -> $dest_file"
}

# Function to build the project and handle errors
build_project() {
  local file="$1"
  local output

  # Redirect both stdout and stderr to the output variable
  output=$(npm run build 2>&1)

  # Check for build failure
  if [[ "$output" == *"ERROR"* ]]; then
    echo "Build failed for: $file"
    echo "Build output:"
    echo "$output"

    # Log the error to the log file
    echo "=== Build error with file: $file ===" >> "$ERROR_LOG_FILE"
    echo "$output" >> "$ERROR_LOG_FILE"
    echo "=====================================" >> "$ERROR_LOG_FILE"

    return 1
  else
    echo "Build successful."
    return 0
  fi
}

# --- Main Script ---

# Clear the error log file
> "$ERROR_LOG_FILE"

# Analyze the tree and get a prioritized list of files
prioritized_files=$(analyze_tree "$SOURCE_DIR")

# Loop through the files, copying and building one by one
while IFS= read -r file; do
  # Construct the destination file path
  dest_file="$DEST_DIR/${file#$SOURCE_DIR/}"

  # Copy the file
  copy_file "$file" "$dest_file"

  # Build the project
  if ! build_project "$file"; then
    # Ask for confirmation to continue or skip
    read -r -p "Do you want to continue to the next file (y), skip this file (s), or exit (n)? [y/s/n]: " response
    case "$response" in
        "s")
        echo "Skipping file: $file"
        ;;
        "n")
        echo "Exiting."
        exit 1
        ;;
        *)
        echo "Continuing with the next file."
        ;;
    esac
  else
      # Ask for confirmation to continue if the build was successful
      read -r -p "Continue to the next file? (y/n): " response
      if [[ "$response" != "y" ]]; then
          echo "Exiting."
          exit 0
      fi
  fi

done <<< "$prioritized_files"

echo "Finished copying and building."