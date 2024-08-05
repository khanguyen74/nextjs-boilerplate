#!/bin/bash

prompt() {
  while true; do
    read -p "$1 (yes/no): " yn
    case $yn in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      * ) echo "Please answer yes or no!!";;
    esac
  done
}

# prompt for project name
read -p "Enter project name: " projectName

# Get the current directory name
currentDir=$(basename "$PWD")

# Rename the current directory to the project name
if [ "$currentDir" != "$projectName" ]; then
    echo -e "Changing directory name..."
    cd ..
    mv "$currentDir" "$projectName"
    cd "$projectName"
fi

echo -e "Initializing git..."

if [ -d ".git" ]; then
  echo "Removing .git, need admin access"
  sudo rm -r .git
fi

git init

echo "Installing packages..."
npm install

if prompt "Do you want to install MUI?"; then
  npm install @mui/material @emotion/react @emotion/styled
  node ./scripts/template.js "$projectName" mui
else
  node ./scripts/template.js "$projectName"
fi


echo "You can now safely delete content in scripts and install.sh"
