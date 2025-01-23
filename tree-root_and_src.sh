#!/bin/zsh

# Colors for better visual organization
BLUE='\033[0;34m'   # Used for directories
GREEN='\033[0;32m'  # Used for files
NC='\033[0m'        # Resets color formatting

# Main function to print the directory tree
print_tree() {
    # Store the current working directory
    local current_dir="$(pwd)"
    local prefix="$1"
    local depth="$2"

    # Get all visible items in the current directory, sorted
    # The (N) qualifier handles the case where no files match
    local items=(*(N))
    
    # Process each item in the directory
    for item in $items; do
        # Get the name of the current item
        local name=${item:t}
        
        # At root level (depth 0), we only want to show src directory
        if [[ $depth -eq 0 && $name != "src" ]]; then
            continue
        fi
        
        # Skip common development directories we don't need to see
        if [[ $name == "node_modules" || $name == ".git" || $name == ".cache" ]]; then
            continue
        fi
        
        # Handle directories and files differently
        if [[ -d $item ]]; then
            # Print directory with blue color
            echo -e "${prefix}├── ${BLUE}${name}${NC}"
            
            # If we haven't reached max depth, process the subdirectory
            if [[ $depth -lt 3 ]]; then
                # Change into the directory
                cd "$item"
                print_tree "$prefix│   " $((depth + 1))
                # Return to previous directory
                cd ..
            fi
        else
            # Print file with green color
            echo -e "${prefix}├── ${GREEN}${name}${NC}"
        fi
    done
}

# Print header
echo "Astro Project Tree (from current directory)"
echo "-----------------------------------------"

# Start the tree printing from current directory
print_tree "" 0