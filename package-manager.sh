#!/bin/bash

# Navigating to server/database directory and installing dependencies
echo "Installing server/database dependencies..."
cd server/database
npm install

# Going back to root directory
cd ../../

# Navigating to web-app directory and installing dependencies
echo "Installing web-app dependencies..."
cd web-app
npm install

# Returning to the root directory
cd ..

# Running the project manager script
echo "Setting up the project..."
./project-manager.sh

echo "Setup complete! You can now start using the project."
