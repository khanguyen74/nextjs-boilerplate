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

echo -e "Initializing git..."

if [ -d ".git"]; then
  rm -r .git
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
