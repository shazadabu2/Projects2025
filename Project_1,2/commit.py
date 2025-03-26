"""Script to analyze code quality"""

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

