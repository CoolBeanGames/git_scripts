#!/bin/bash

# This script acts as a launcher for various Git-related shell scripts.
# It assumes all the listed scripts are in the same directory as this launcher.

# Define an associative array mapping menu options to script filenames
declare -A SCRIPTS=(
    ["1"]="add_to_git_ignore.sh"
    ["2"]="git_ssh_setup.sh" # Corresponds to auth_git_ssh
    ["3"]="clone_repo.sh"
    ["4"]="create_git_branch.sh" # Corresponds to create_branch
    ["5"]="create_git_repo.sh"   # Corresponds to create_repo
    ["6"]="git_pull.sh"
    ["7"]="git_push.sh"
    ["8"]="git_merge_script.sh"  # Corresponds to merge_branch
    ["9"]="git_branch_switcher.sh" # Corresponds to switch_branch
)

# Define descriptive names for the menu
declare -A SCRIPT_NAMES=(
    ["add_to_git_ignore.sh"]="Add to .gitignore"
    ["git_ssh_setup.sh"]="Auth Git & Generate SSH Key"
    ["clone_repo.sh"]="Clone a Repository"
    ["create_git_branch.sh"]="Create New Branch"
    ["create_git_repo.sh"]="Create New Repository"
    ["git_pull.sh"]="Pull Latest Changes"
    ["git_push.sh"]="Push Changes"
    ["git_merge_script.sh"]="Merge Branches"
    ["git_branch_switcher.sh"]="List & Switch Branch"
)

echo "--- Git Workflow Launcher ---"
echo "Select a Git operation to perform:"
echo ""

# Display the menu
for i in "${!SCRIPTS[@]}"; do
    SCRIPT_FILE=${SCRIPTS[$i]}
    SCRIPT_DESC=${SCRIPT_NAMES[$SCRIPT_FILE]}
    echo "$i. $SCRIPT_DESC"
done
echo "0. Exit"
echo ""

read -p "Enter your choice (0-$((${#SCRIPTS[@]}))): " CHOICE

# Get the directory of the current script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ "$CHOICE" -eq 0 ]; then
    echo "Exiting Git Workflow Launcher. Goodbye!"
    exit 0
elif [[ -v SCRIPTS[$CHOICE] ]]; then
    SELECTED_SCRIPT="${SCRIPTS[$CHOICE]}"
    FULL_SCRIPT_PATH="$SCRIPT_DIR/$SELECTED_SCRIPT"

    if [ -f "$FULL_SCRIPT_PATH" ]; then
        echo ""
        echo "--- Running '${SCRIPT_NAMES[$SELECTED_SCRIPT]}' ---"
        # Execute the selected script
        bash "$FULL_SCRIPT_PATH"
        echo ""
        echo "--- '${SCRIPT_NAMES[$SELECTED_SCRIPT]}' Finished ---"
    else
        echo "Error: Script '$SELECTED_SCRIPT' not found in '$SCRIPT_DIR'."
        echo "Please ensure all scripts are in the same directory."
    fi
else
    echo "Invalid choice. Please enter a number from the menu."
fi

echo "--- Launcher Finished ---"
