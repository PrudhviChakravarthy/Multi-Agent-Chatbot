#!/bin/bash
# Script: update-requirements.sh
# This script:
# 1. Finds a Python virtual environment in the current directory
# 2. Installs packages from requirements.txt if it exists
# 3. Updates requirements.txt with the current pip freeze output

# Function to find virtual environment in current directory
find_virtual_env() {
    # Common virtual environment folder names
    env_folders=("env" "venv" ".env" ".venv" "virtualenv")
    
    for folder in "${env_folders[@]}"; do
        if [ -d "$folder" ]; then
            activate_path="$folder/bin/activate"
            if [ -f "$activate_path" ]; then
                echo "$folder"
                return 0
            fi
        fi
    done
    
    # If no environment found in common folders, search the current directory
    for dir in */; do
        activate_path="${dir%/}/bin/activate"
        if [ -f "$activate_path" ]; then
            echo "${dir%/}"
            return 0
        fi
    done
    
    return 1
}

# Main script execution
set -e

# Try to find a virtual environment
env_path=$(find_virtual_env)

if [ -z "$env_path" ]; then
    echo "Error: Could not find a virtual environment in the current directory." >&2
    echo "Please create a virtual environment or specify the path manually." >&2
    exit 1
fi

# Determine the activate script location
activate_script="$env_path/bin/activate"

echo -e "\033[0;32mFound virtual environment at: $env_path\033[0m"
echo -e "\033[0;32mActivating virtual environment...\033[0m"

# Activate the virtual environment
source "$activate_script"

# Check if activation was successful
if [ -z "$VIRTUAL_ENV" ]; then
    echo "Error: Failed to activate the virtual environment." >&2
    exit 1
fi

echo -e "\033[0;32mVirtual environment activated successfully.\033[0m"

# Check if requirements.txt exists and install packages if it does
requirements_path="requirements.txt"
if [ -f "$requirements_path" ]; then
    echo -e "\033[0;32mFound existing requirements.txt file. Installing packages...\033[0m"
    
    # Install packages from requirements.txt
    pip install -r "$requirements_path"
    
    if [ $? -ne 0 ]; then
        echo -e "\033[0;33mWarning: Some packages may have failed to install. Continuing anyway...\033[0m" >&2
    else
        echo -e "\033[0;32mSuccessfully installed packages from requirements.txt\033[0m"
    fi
else
    echo -e "\033[0;33mNo existing requirements.txt found. Will create a new one.\033[0m"
fi

# Update requirements.txt with current environment packages
echo -e "\033[0;32mUpdating requirements.txt file with current environment packages...\033[0m"

# Run pip freeze and capture the output properly
pip freeze > "$requirements_path"

# Check if requirements.txt was created successfully
if [ -f "$requirements_path" ]; then
    package_count=$(wc -l < "$requirements_path")
    echo -e "\033[0;32mSuccessfully updated requirements.txt with $package_count package(s).\033[0m"
    echo -e "\033[0;32mFile saved at: $(realpath "$requirements_path")\033[0m"
    
    # Display the first few lines of the file as confirmation
    echo -e "\n\033[0;36mFirst few lines of requirements.txt:\033[0m"
    head -n 5 "$requirements_path" | while read -r line; do
        echo -e "  \033[0;37m$line\033[0m"
    done
else
    echo "Error: Failed to update requirements.txt." >&2
    exit 1
fi

# Deactivate the virtual environment
deactivate
echo -e "\033[0;32mVirtual environment deactivated.\033[0m"