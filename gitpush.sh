#!/bin/bash

# ------------------------------------------
#  SAFE Git Push Script for Gekinzen
# ------------------------------------------

# Location of your stored GitHub token
TOKEN_FILE="$HOME/.config/github_token"

# Check if token file exists
if [ ! -f "$TOKEN_FILE" ]; then
    echo "[ERROR] GitHub token file not found at: $TOKEN_FILE"
    echo "Create it with:  nano ~/.config/github_token"
    exit 1
fi

# Load token
GITHUB_TOKEN=$(cat "$TOKEN_FILE")

# Repo URL
REPO_URL="https://$GITHUB_TOKEN@github.com/Gekinzen/DarkMatter-Shell-V2.git"

# Set remote URL safely
git remote set-url origin "$REPO_URL"

# Require commit message
if [ -z "$1" ]; then
    echo "Usage: ./gitpush.sh \"your commit message\""
    exit 1
fi

# Run Git commands
echo "[INFO] Staging all changes..."
git add .

echo "[INFO] Committing changes..."
git commit -m "$1"

echo "[INFO] Pushing to GitHub..."
git push

echo "[DONE] Push complete!"
