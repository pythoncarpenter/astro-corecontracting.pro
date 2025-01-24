#!/bin/bash

# Display the tree structure of the project's root directory, excluding system and build files
echo "Project Root Directory:"
tree -a -I '.git|.astro|node_modules|dist|.netlify|.DS_Store'

# Display the tree structure of the src directory, excluding specific file types
echo -e "\n\nSource Directory (src):"
tree src -a -I '.DS_Store'