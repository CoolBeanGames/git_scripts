#!/bin/bash

# Determine the directory where this script is located
# This assumes the script is directly inside the directory containing all your Git repos
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
GIT_ROOT_DIR="$SCRIPT_DIR"

# Check if the root directory exists (should always if the script is there)
if [ ! -d "$GIT_ROOT_DIR" ]; then
    echo "Error: Git root directory '$GIT_ROOT_DIR' not found."
    exit 1
fi

echo "--- Starting Git Pull for Repos in: $GIT_ROOT_DIR ---"
echo ""

# Loop through each item in the Git root directory
for dir in "$GIT_ROOT_DIR"/*/; do
    # Remove trailing slash to get the directory name correctly
    dir=${dir%/}
    repo_name=$(basename "$dir")

    # Check if it's a directory and contains a .git subdirectory
    if [ -d "$dir/.git" ]; then
        echo "--- Processing: $repo_name ---"
        (
            cd "$dir" || exit # Change to the repository directory
            echo "Pulling latest changes for $repo_name..."
            # Using 'git pull' for a standard pull, you could use 'git pull --ff-only' to prevent merge commits
            git pull
            echo ""
        )
    else
        echo "Skipping: $repo_name (Not a Git repository or .git directory not found)"
        echo ""
    fi
done

echo "--- Git Pull process completed! ---"

# --- Press Enter to close prompt ---
read -n 1 -s -r -p "Press Enter to close..."
echo # Add a newline after the prompt