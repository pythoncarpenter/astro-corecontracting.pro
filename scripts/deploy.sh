#!/usr/bin/env bash
set -euo pipefail

# Directory configuration
PROJECT_DIR="/Users/mitchmcquoid/z9b-projects/business_proj/astro-corecontracting.pro"
PUBLISH_DIR="$PROJECT_DIR/dist"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

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

# Build the project
echo -e "${BLUE}Running npm build...${NC}"
npm run build
check_status

# Small delay to ensure build is complete
sleep 2

# Deploy to Netlify using human-readable output
echo -e "${BLUE}Deploying to Netlify...${NC}"
NETLIFY_OUTPUT=$( { printf "dist\n"; } | netlify deploy --dir=dist )
echo "$NETLIFY_OUTPUT"
check_status

# Extract the draft URL from the deploy output.
# Expected output line: "Website draft URL:  https://<unique-id>--corecontractingpro.netlify.app"
DRAFT_URL=$(echo "$NETLIFY_OUTPUT" | grep "Website draft URL:" | awk '{print $NF}')

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