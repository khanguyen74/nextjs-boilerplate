#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to prompt for user input
prompt() {
    local promptText="$1"
    local userInput
    echo -n "${BLUE}$promptText (yes/no): ${NC}"
    read userInput
    while [[ "$userInput" != "yes" && "$userInput" != "no" && "$userInput" != "y" && "$userInput" != "n" ]]; do
        echo -e "${RED}Please answer yes or no.${NC}"
        echo -n "${BLUE}$promptText (yes/no): ${NC}"
        read userInput
    done
    [[ "$userInput" == "yes" || "$userInput" == "y" ]] && return 0 || return 1
}

# Prompt for project name
echo -n "${BLUE}Enter project name: ${NC}"
read projectName

# Validate project name
if [ -z "$projectName" ]; then
    echo -e "${RED}Project name cannot be empty. Exiting.${NC}"
    exit 1
fi

# Get the current directory name
currentDir=$(basename "$PWD")

# Rename the current directory to the project name
if [ "$currentDir" != "$projectName" ]; then
    echo -e "${YELLOW}Changing directory name...${NC}"
    cd ..
    mv "$currentDir" "$projectName"
    cd "$projectName"
fi

echo -e "${GREEN}Initializing git...${NC}"

if [ -d ".git" ]; then
    echo -e "${RED}Removing .git, need admin access${NC}"
    sudo rm -r .git
fi

git init

echo -e "${GREEN}Installing packages...${NC}"
npm install

if prompt "Do you want to install MUI?"; then
    npm install @mui/material @emotion/react @emotion/styled
    node ./scripts/template.js "$projectName" mui
else
    node ./scripts/template.js "$projectName"
fi

echo -e "${YELLOW}You can now safely delete content in scripts and install.sh${NC}"
