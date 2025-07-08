#!/bin/bash

# Determine the directory where this script is located
# This assumes the script is directly inside the directory containing all your Git repos
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
GIT_ROOT_DIR="$SCRIPT_DIR"

# Check if the root directory exists
if [ ! -d "$GIT_ROOT_DIR" ]; then
    echo "Error: Git root directory '$GIT_ROOT_DIR' not found."
    exit 1
fi

echo "--- Starting Git Push for Repos in: $GIT_ROOT_DIR ---"
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

            # Check if there are any commits to push (e.g., local branch is ahead of remote)
            # This comparison assumes the current branch is tracking an upstream branch.
            # You might need to adjust this logic if you have complex branching or no upstream.
            if git status | grep -q "Your branch is ahead of"; then
                echo "Pushing changes for $repo_name..."
                git add .
                git push
            elif git status | grep -q "nothing to commit, working tree clean" && git status | grep -q "Your branch is up to date"; then
                echo "No local changes to push for $repo_name (branch is up to date)."
            else
                echo "Skipping push for $repo_name: No commits to push or uncertain state."
                echo "You may need to commit changes first or resolve merge conflicts."
                git status # Show status for manual review
            fi
            echo ""
        )
    else
        echo "Skipping: $repo_name (Not a Git repository or .git directory not found)"
        echo ""
    fi
done

echo "--- Git Push process completed! ---"

# --- Press Enter to close prompt ---
read -n 1 -s -r -p "Press Enter to close..."
echo # Add a newline after the prompt