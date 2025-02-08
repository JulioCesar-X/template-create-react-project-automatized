#!/bin/bash

# Function to safely update `package.json`
update_package_json() {
  local username="$1"
  local project_name="$2"

  # Use jq to safely update the JSON
  jq --arg homepage "https://$username.github.io/$project_name" \
    '.homepage = $homepage | .scripts += { "predeploy": "npm run build", "deploy": "gh-pages -d build" }' \
    package.json > package.json.tmp && mv package.json.tmp package.json

  # Validate the updated JSON
  if ! jq empty package.json >/dev/null 2>&1; then
    echo "Error: Invalid JSON generated in package.json"
    exit 1
  fi
}

# Check if the project name was provided
if [ -z "$1" ]; then
  echo "Usage: $0 <project-name>"
  exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "❯ 'jq' is required for this script. Please install it and try again."
  echo "For example, on Debian/Ubuntu: sudo apt install jq"
  exit 1
fi

# Project name
PROJECT_NAME=$1

# Create the React project
echo "Choose the React version:"
echo "1) React 17"
echo "2) React 18"
echo "3) Latest (default)"
read -p "Enter your choice [1-3]: " REACT_VERSION

case $REACT_VERSION in
  1)
    echo "Creating React project with React 17..."
    npx create-react-app "$PROJECT_NAME" --template cra-template-pwa
    cd "$PROJECT_NAME" || exit
    npm install react@17 react-dom@17
    ;;
  2)
    echo "Creating React project with React 18..."
    npx create-react-app "$PROJECT_NAME" --template cra-template-pwa
    cd "$PROJECT_NAME" || exit
    npm install react@18 react-dom@18
    ;;
  3|*)
    echo "Creating React project with the latest version..."
    npx create-react-app "$PROJECT_NAME" --template cra-template-pwa
    cd "$PROJECT_NAME" || exit
    ;;
esac

# Create the basic folder structure
mkdir -p src/components src/styles src/hooks src/context src/utils

# Ask for the number of components and create them
read -p "How many components do you want to create? " NUM_COMPONENTS
for ((i = 1; i <= NUM_COMPONENTS; i++)); do
  read -p "Enter the name of component $i: " COMPONENT_NAME
  cat > src/components/"$COMPONENT_NAME".js <<EOF
import React from 'react';

function $COMPONENT_NAME() {
  return (
    <div>
      <h2>$COMPONENT_NAME Component</h2>
    </div>
  );
}

export default $COMPONENT_NAME;
EOF
  echo "Component src/components/$COMPONENT_NAME.js created."
done

# Styling: SASS, Bootstrap, Tailwind CSS
echo "Choose a styling framework or preprocessor:"
echo "1) SASS"
echo "2) Bootstrap"
echo "3) Tailwind CSS"
echo "4) None"
read -p "Enter your choice [1-4]: " STYLE_CHOICE

case $STYLE_CHOICE in
  1)
    echo "Setting up SASS..."
    npm install sass
    # Ask for the number of SCSS files and create them
    read -p "How many .scss files do you want to create? " NUM_SCSS
    for ((i = 1; i <= NUM_SCSS; i++)); do
      read -p "Enter the name of SCSS file $i (without extension): " SCSS_NAME
      cat > src/styles/"$SCSS_NAME".scss <<EOF
/* Styles for $SCSS_NAME */
.${SCSS_NAME} {
  /* Add your styles here */
}
EOF
      echo "SCSS file src/styles/$SCSS_NAME.scss created."
    done
    cat > src/styles/global.scss <<EOF
/* Global styles */
body {
  margin: 0;
  font-family: Arial, sans-serif;
}
EOF
    ;;
  2)
    echo "Setting up Bootstrap..."
    npm install bootstrap
    cat > src/index.js <<EOF
import 'bootstrap/dist/css/bootstrap.min.css';
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);
EOF
    ;;
  3)
    echo "Setting up Tailwind CSS..."
    npm install -D tailwindcss postcss autoprefixer
    npx tailwindcss init
    cat > tailwind.config.js <<EOF
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
};
EOF
    cat > src/styles/tailwind.css <<EOF
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF
    ;;
  4)
    echo "No styling framework selected."
    ;;
  *)
    echo "Invalid option. No styling framework will be configured."
    ;;
esac

# State Management: Redux, Zustand, Recoil
echo "Choose a state management library:"
echo "1) Redux"
echo "2) Zustand"
echo "3) Recoil"
echo "4) None"
read -p "Enter your choice [1-4]: " STATE_MANAGEMENT_CHOICE

case $STATE_MANAGEMENT_CHOICE in
  1)
    echo "Setting up Redux..."
    npm install redux react-redux @reduxjs/toolkit
    mkdir -p src/store
    cat > src/store/store.js <<EOF
import { configureStore } from '@reduxjs/toolkit';

const store = configureStore({
  reducer: {},
});

export default store;
EOF
    ;;
  2)
    echo "Setting up Zustand..."
    npm install zustand
    cat > src/store/useStore.js <<EOF
import create from 'zustand';

const useStore = create((set) => ({
  example: 'Hello Zustand!',
  setExample: (newExample) => set({ example: newExample }),
}));

export default useStore;
EOF
    ;;
  3)
    echo "Setting up Recoil..."
    npm install recoil
    mkdir -p src/store
    cat > src/store/state.js <<EOF
import { atom } from 'recoil';

export const exampleState = atom({
  key: 'exampleState',
  default: 'Hello Recoil!',
});
EOF
    ;;
  4)
    echo "No state management library selected."
    ;;
  *)
    echo "Invalid option. No state management library will be configured."
    ;;
esac

# Ask about Next.js support
read -p "Do you want to include Next.js support in the project? (y/n) " INCLUDE_NEXT
if [ "$INCLUDE_NEXT" == "y" ]; then
  npm install next react react-dom
  mkdir -p pages
  cat > pages/index.js <<EOF
export default function Home() {
  return <h1>Welcome to the React project with Next.js support!</h1>;
}
EOF
  echo "Next.js support configured."
fi

# Deploy to GitHub Pages
read -p "Enter your GitHub username (for deployment): " GITHUB_USERNAME

# Call update_package_json at the end of the script
update_package_json "$GITHUB_USERNAME" "$PROJECT_NAME"

# Docker setup
read -p "Do you want to configure Docker support? (y/n) " USE_DOCKER
if [ "$USE_DOCKER" == "y" ]; then
  cat > Dockerfile <<EOF
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
EOF
fi

# Finalization
echo "React project \"$PROJECT_NAME\" successfully configured!"
