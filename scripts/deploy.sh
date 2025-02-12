#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined var, and handle pipeline errors

# Directory configuration
PROJECT_DIR="/Users/mitchmcquoid/z9b-projects/business_proj/astro-corecontracting.pro"
PUBLISH_DIR="$PROJECT_DIR/dist"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if previous command was successful
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Success${NC}"
    else
        echo "Error occurred. Exiting..."
        exit 1
    fi
}

echo -e "${YELLOW}=== Core Contracting Quick Deploy ===${NC}"

cd "$PROJECT_DIR" || exit 1
echo -e "${BLUE}Starting deployment process...${NC}"

# Build the project (uncomment if needed)
echo -e "${BLUE}Running npm build...${NC}"
npm run build
check_status

# Small delay to ensure build is complete
sleep 2

# Deploy to Netlify with automated input and JSON output
echo -e "${BLUE}Deploying to Netlify...${NC}"
# Capture deploy output as JSON; assuming "dist" is your publish directory.
NETLIFY_OUTPUT=$( { printf "dist\n"; } | netlify deploy --json )
echo "$NETLIFY_OUTPUT"
check_status

# Extract the draft URL from the JSON output using jq.
if command -v jq >/dev/null 2>&1; then
    DRAFT_URL=$(echo "$NETLIFY_OUTPUT" | jq -r '.deploy_url')
else
    echo "Error: jq is required for parsing the Netlify deploy output." >&2
    exit 1
fi

if [ -z "$DRAFT_URL" ]; then
    echo "Draft URL not found in deploy output."
    exit 1
else
    echo -e "${GREEN}Draft URL: ${DRAFT_URL}${NC}"
fi

echo -e "${GREEN}✓ Quick deploy completed!${NC}"
echo -e "${YELLOW}To deploy to production, run:${NC} netlify deploy --prod"

# If the first argument is "pw", run Playwright tests against the draft URL.
if [ "${1:-}" = "pw" ]; then
    echo -e "${BLUE}Running Playwright tests on draft URL...${NC}"
    export BASE_URL="$DRAFT_URL"
    echo -e "${BLUE}BASE_URL set to ${BASE_URL}${NC}"
    npx playwright test
fi