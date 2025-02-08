#!/bin/bash
# Usage: ./concat_versions.sh <oldest_commit> <latest_commit> <file_path>
# Example:
#   ./concat_versions.sh 03c14b787d5b1d99eea06108aa4f473c743e8eba 7f8d9e0babcde1234567890abcdef1234567890 src/pages/YourFile.astro

# Check if the current directory is part of a Git repository.
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not a git repository. Please run this script from the root of a Git repository." >&2
    exit 1
fi

# Ensure exactly three arguments are provided.
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <oldest_commit> <latest_commit> <file_path>" >&2
    exit 1
fi

# Assign arguments to variables.
OLDEST_COMMIT=$1
LATEST_COMMIT=$2
FILE_PATH=$3

OUTPUT_FILE="combined_versions.txt"
# Clear the output file or create a new one.
> "$OUTPUT_FILE"

# Loop over all commits in chronological order from OLDEST_COMMIT to LATEST_COMMIT.
# The range ${OLDEST_COMMIT}^..${LATEST_COMMIT} ensures that the version from the oldest commit is included.
for commit in $(git rev-list --reverse ${OLDEST_COMMIT}^..${LATEST_COMMIT}); do
    echo "===== Commit: $commit =====" >> "$OUTPUT_FILE"
    git show "$commit":"$FILE_PATH" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"  # Add an empty line for separation.
done

echo "Combined file versions saved in $OUTPUT_FILE"