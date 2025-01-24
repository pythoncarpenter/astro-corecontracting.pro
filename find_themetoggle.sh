#!/bin/bash

# The file we're interested in
file="src/components/ThemeToggle.astro"

# Get the commit history for the file, since a specific date
commits=$(git log --pretty=format:"%H" --since="2023-01-01" -- "$file")

# Loop through each commit
while read -r commit; do
  echo "----------------------------------------"
  echo "Commit: $commit"
  echo "----------------------------------------"

  # Show the diff for this commit, only for the specified file
  git diff "$commit"^ "$commit" -- "$file"

  # Ask the user if this is the correct version
  read -r -p "Is this the correct version? (y/n): " choice

  if [[ "$choice" == "y" ]]; then
    echo "Restoring file to commit: $commit"
    git checkout "$commit" -- "$file"
    exit 0 # Exit the script successfully
  fi
done

echo "Correct version not found."
exit 1 # Exit the script with an error code