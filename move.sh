#!/bin/bash

# Source project directory (your original project)
SOURCE_DIR="/Users/mitchmcquoid/z9b-projects/business_proj/astro-corecontracting.pro"

# Destination project directory (the new minimal reproduction project)
DEST_DIR="/Users/mitchmcquoid/z9b-projects/business_proj/new-astro"  # **Change this to the actual path of your minimal-repro project**

# Create the destination directories if they don't exist
mkdir -p "$DEST_DIR/src/layouts"
mkdir -p "$DEST_DIR/src/components"

# Copy the essential files
cp "$SOURCE_DIR/astro.config.mjs" "$DEST_DIR/"
cp "$SOURCE_DIR/src/layouts/Layout.astro" "$DEST_DIR/src/layouts/"
cp "$SOURCE_DIR/src/components/Header.astro" "$DEST_DIR/src/components/"
cp "$SOURCE_DIR/src/components/SchemeToggle.astro" "$DEST_DIR/src/components/"

# Copy package.json (dependencies and scripts only)
jq '{ dependencies, scripts }' "$SOURCE_DIR/package.json" > "$DEST_DIR/package.json"

# Optional: Copy CSS files (if applicable)
# If you have CSS files that are directly used by the copied components,
# copy them over as well. For example:
# cp "$SOURCE_DIR/src/styles/header.css" "$DEST_DIR/src/styles/"

echo "Files copied successfully to: $DEST_DIR"
echo "Next steps:"
echo "1. cd $DEST_DIR"
echo "2. npm install"
echo "3. npm run build"