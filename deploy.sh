#!/bin/zsh

# Check if we're running in zsh
if [[ ! "$ZSH_NAME" ]]; then
    echo "Please run this script with zsh"
    exit 1
fi

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

# Print header
echo -e "${YELLOW}=== Core Contracting Quick Deploy ===${NC}"

# Navigate to project directory
cd "$PROJECT_DIR"
echo -e "${BLUE}Starting deployment process...${NC}"

# Run build command
echo -e "${BLUE}Running npm build...${NC}"
npm run build
check_status

# Small delay to ensure build is complete
sleep 2

# Run netlify deploy with automated input
echo -e "${BLUE}Deploying to Netlify...${NC}"
{ printf "dist\n"; } | netlify deploy
check_status

echo -e "${GREEN}✓ Quick deploy completed!${NC}"
echo -e "${YELLOW}To deploy to production, run:${NC} netlify deploy --prod"