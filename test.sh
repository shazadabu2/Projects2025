C:\Users\is10839\AppData\Roaming\Python\Python311\Scripts\poetry


echo "Step 1: Installing cookiecutter-poetry"
echo "################################################################"
pip install cookiecutter-poetry

echo "################################################################"
echo "Step 2: Please Enter Project details"
ccp || exit

echo "################################################################"
echo "Step 3: creating folders"
current_dir=$(pwd)
recent_dir=$(ls -td -- */ |head -n 1)
cd "$current_dir/$recent_dir" && mkdir {"Notebooks/","data/","config/"}

echo "################################################################"
echo "Step 4: Adding code quality script -> commit.py"
script='''"""Script to score code quality"""

import os
import subprocess


def analyze_code(directory):
    """walk the directory, get all python files and then
       check for code quality.
    Args:
        directory (str): folder directory
    """
    print(directory)
    python_files = []
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".py"):
                if not any(x in root for x in [".venv", "Notebooks", "data"]):
                    python_files.append(os.path.join(root, file))

    if not python_files:
        print("no python files found in the directory")
        return

    # Analyzing each file
    for file in python_files:
        print(f"Analyzing file... {file}")
        file_path = os.path.join(directory, file)

        # run black
        print("\nRunning black...\n")
        command = f"black {file_path}"
        subprocess.run(command, shell=True)

        # run pylint
        print("\nRunning Pylint...\n")
        command = f"pylint {file_path}"
        subprocess.run(command, shell=True)

        print("\nRunning Flake8...\n")
        command = f"flake8 {file_path}"
        subprocess.run(command, shell=True)


if __name__ == "__main__":
    analyze_code(os.getcwd())
'''
cd "$current_dir/$recent_dir"  && echo "$script">commit.py

sed -i 's/python = ">=3.8,<4.0"/python = ">=3.9,<3.13"/' "$current_dir/$recent_dir/pyproject.toml"
echo "Final cleanup"
echo "Adding Essential Packages"
echo "Installing black..."
cd "$current_dir/$recent_dir"  && poetry add black
echo "Installing pylint"
cd "$current_dir/$recent_dir"  && poetry add pylint
file_path="$current_dir/$recent_dir/pyproject.toml"
echo "Creating ipython kernel"
cd "$current_dir/$recent_dir"  && poetry add ipykernel
recent_dir_sanitized=${recent_dir//\//_}
recent_dir_sanitized=${recent_dir_sanitized//-/_}
cd "$current_dir/$recent_dir" && poetry run python -m ipykernel install --user --name "${recent_dir_sanitized}p_env"
cd "$current_dir/$recent_dir" && touch ".env"
echo "################################################################"

