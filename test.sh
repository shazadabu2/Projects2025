#!/bin/bash
set -e

echo "################################################################"
echo "Step 1: Installing cookiecutter-poetry"
echo "################################################################"
pip install cookiecutter-poetry

echo "################################################################"
echo "Step 2: Please Enter Project details"
ccp || exit

echo "################################################################"
echo "Step 3: Creating project directories"
current_dir=$(pwd)
recent_dir=$(ls -td -- */ | head -n 1)
cd "$current_dir/$recent_dir"

# Create common ML project folders
mkdir -p Notebooks data config models scripts tests docker

echo "################################################################"
echo "Step 4: Adding code quality script -> commit.py"
script='''"""Script to analyze code quality"""

import os
import subprocess

def analyze_code(directory):
    """Walk the directory, get all python files and then check code quality.
    Args:
        directory (str): folder directory
    """
    print(f"Analyzing directory: {directory}")
    python_files = []
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".py"):
                if not any(skip in root for skip in [".venv", "Notebooks", "data", "models", "docker"]):
                    python_files.append(os.path.join(root, file))

    if not python_files:
        print("No python files found in the directory")
        return

    for file in python_files:
        print(f"\nAnalyzing file: {file}")
        for tool in [("black", "black"), ("pylint", "pylint"), ("flake8", "flake8")]:
            name, cmd = tool
            print(f"\nRunning {name} on {file}...\n")
            subprocess.run(f"{cmd} {file}", shell=True)

if __name__ == "__main__":
    analyze_code(os.getcwd())
'''
echo "$script" > commit.py

echo "################################################################"
echo "Step 5: Creating sample test file in tests/"
cat << 'EOF' > tests/test_sample.py
import pytest

def test_example():
    # Sample test: modify as needed for your project
    assert 1 + 1 == 2

if __name__ == "__main__":
    pytest.main()
EOF

echo "################################################################"
echo "Step 6: Creating pre-commit configuration"
cat << 'EOF' > .pre-commit-config.yaml
repos:
  - repo: https://github.com/psf/black
    rev: 23.1.0  # change as appropriate
    hooks:
      - id: black
  - repo: https://github.com/PyCQA/flake8
    rev: 6.0.0  # change as appropriate
    hooks:
      - id: flake8
EOF

echo "################################################################"
echo "Step 7: Adding/Updating pyproject.toml Python version and MLops dependencies"
sed -i 's/python = ">=3.8,<4.0"/python = ">=3.9,<3.13"/' pyproject.toml

# Add essential packages using Poetry
echo "Installing code quality tools..."
poetry add black pylint flake8 ipykernel

echo "Installing testing framework..."
poetry add --dev pytest

echo "Installing pre-commit hook manager..."
poetry add --dev pre-commit

# Prompt user for optional MLops tools
read -p "Do you want to include DVC for data versioning? (y/n): " include_dvc
if [[ "$include_dvc" =~ ^[Yy]$ ]]; then
    echo "Installing DVC..."
    poetry add dvc
fi

read -p "Do you want to include Weights & Biases (wandb) for experiment tracking? (y/n): " include_wandb
if [[ "$include_wandb" =~ ^[Yy]$ ]]; then
    echo "Installing wandb..."
    poetry add wandb
fi

echo "################################################################"
echo "Step 8: Creating an IPython kernel for Jupyter notebooks"
recent_dir_sanitized=${recent_dir//\//_}
recent_dir_sanitized=${recent_dir_sanitized//-/_}
poetry run python -m ipykernel install --user --name "${recent_dir_sanitized}p_env"

echo "################################################################"
echo "Step 9: Adding a sample Dockerfile for containerization"
cat << 'EOF' > docker/Dockerfile
# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install project dependencies using Poetry
RUN pip install poetry && poetry config virtualenvs.create false && poetry install --no-dev

# Expose port (modify if your app serves on a different port)
EXPOSE 8000

# Run the application (modify to your entrypoint)
CMD ["python", "scripts/main.py"]
EOF

echo "################################################################"
echo "Step 10: Final cleanup and environment file"
touch .env

echo "Project setup complete! You can now run tests with 'poetry run pytest', check code quality with 'python commit.py', and manage pre-commit hooks with 'pre-commit install'."

