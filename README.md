# Template: Create React Project Automatized

This repository contains a highly customizable Bash script, `create-react-project.sh`, designed to automate the setup of React projects. It simplifies the process of creating a React application, adding optional integrations for state management, styling frameworks, Next.js support, GitHub Pages deployment, and Docker configuration.

## Features

- **React Setup**: Create a React project with your choice of version:
  - React 17
  - React 18
  - Latest version

- **Styling Frameworks**: Choose your preferred styling solution:
  - SASS
  - Bootstrap
  - Tailwind CSS
  - None (default)

- **State Management**: Select from modern state management libraries:
  - Redux (with Redux Toolkit)
  - Zustand
  - Recoil
  - None (default)

- **Next.js Support**: Add Next.js for server-side rendering (SSR) and static site generation (SSG).

- **GitHub Pages Deployment**: Configure deployment scripts for GitHub Pages with a single command.

- **Docker Integration**: Generate a `Dockerfile` for containerized development and deployment.

- **Custom Folder Structure**: Automatically sets up a modular folder structure:
  ```
  src/
  ├── components/
  ├── styles/
  ├── hooks/
  ├── context/
  ├── utils/
  ```

## How It Works

The script guides you through an interactive setup process, allowing you to customize the project based on your requirements. You can skip features that you don't need, ensuring a lightweight and focused project setup.

## Usage

### 1. Clone This Repository
Clone the repository to your local machine:
```bash
git clone https://github.com/JulioCesar-X/template-create-react-project-automatized.git
cd template-create-react-project-automatized
```

### 2. Make the Script Executable
Run the following command to make the script executable:
```bash
chmod +x create-react-project.sh
```

### 3. Run the Script
Use the script to create a new React project:
```bash
./create-react-project.sh <project-name>
```

### 4. Follow the Prompts
The script will guide you through the following steps:
1. **React Version**: Choose React 17, React 18, or the latest version.
2. **Styling Framework**: Select SASS, Bootstrap, Tailwind CSS, or none.
3. **State Management**: Choose Redux, Zustand, Recoil, or none.
4. **Next.js Support**: Optionally include Next.js.
5. **GitHub Pages Deployment**: Configure deployment scripts for GitHub Pages.
6. **Docker Support**: Optionally create a `Dockerfile`.

## Example Output

A fully configured project might have the following structure:
```
<project-name>/
├── src/
│   ├── components/
│   ├── styles/
│   │   ├── global.scss (if SASS selected)
│   │   ├── tailwind.css (if Tailwind CSS selected)
│   ├── hooks/
│   ├── context/
│   ├── utils/
├── package.json
├── Dockerfile (if Docker selected)
├── tailwind.config.js (if Tailwind CSS selected)
├── pages/ (if Next.js included)
├── README.md
```

## Requirements

- **Bash Shell**: The script is designed to run in a Unix-like environment.
- **Node.js**: Make sure you have Node.js installed.
- **npx**: Comes pre-installed with Node.js.
- **Git**: Required for cloning and optional GitHub Pages deployment.

## Contributions

Contributions, bug reports, and feature requests are welcome! Feel free to fork this repository and submit a pull request.

Happy coding! 🚀