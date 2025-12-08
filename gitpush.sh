#!/bin/bash

# ---------------------------------------------------
#  Zenith Git Push (Safe, Branch-Aware, No Remote Mod)
# ---------------------------------------------------

# Colors
GREEN="\e[92m"
YELLOW="\e[93m"
RED="\e[91m"
RESET="\e[0m"

echo -e "${GREEN}Zenith Git Push Utility Loaded${RESET}"

# ---------------------------------------------------
# 1. Load GitHub Token
# ---------------------------------------------------
TOKEN_FILE="$HOME/.config/github_token"

if [ ! -f "$TOKEN_FILE" ]; then
    echo -e "${RED}[ERROR] Token file missing: $TOKEN_FILE${RESET}"
    exit 1
fi

GITHUB_TOKEN=$(cat "$TOKEN_FILE")

# ---------------------------------------------------
# 2. Detect Repo & Branch
# ---------------------------------------------------
CURRENT_URL=$(git remote get-url origin 2>/dev/null)

if [ -z "$CURRENT_URL" ]; then
    echo -e "${RED}[ERROR] No Git remote named 'origin' found!${RESET}"
    exit 1
fi

BRANCH=$(git branch --show-current)

if [ -z "$BRANCH" ]; then
    echo -e "${RED}[ERROR] You are not on a branch!${RESET}"
    exit 1
fi

echo -e "${GREEN}Active Branch:${RESET} $BRANCH"
echo -e "${YELLOW}Origin URL:${RESET} $CURRENT_URL"

# ---------------------------------------------------
# 3. Build Tokenized URL (Temporary)
# ---------------------------------------------------
if [[ "$CURRENT_URL" == https://* ]]; then
    PUSH_URL=$(echo "$CURRENT_URL" | sed -E "s#https://#https://$GITHUB_TOKEN@#")
else
    echo -e "${RED}[ERROR] Repo must use HTTPS remote URL for token auth.${RESET}"
    exit 1
fi

# ---------------------------------------------------
# 4. Commit Message
# ---------------------------------------------------
if [ -z "$1" ]; then
    echo -e "${YELLOW}[WARN] No commit message. Using default.${RESET}"
    COMMIT_MSG="update: auto-push"
else
    COMMIT_MSG="$1"
fi

# ---------------------------------------------------
# 5. Git Actions
# ---------------------------------------------------
echo -e "${YELLOW}[INFO] Staging changes...${RESET}"
git add -A

echo -e "${YELLOW}[INFO] Committing...${RESET}"
git commit -m "$COMMIT_MSG"

echo -e "${YELLOW}[INFO] Pushing to '$BRANCH'...${RESET}"

# TEMPORARY authenticated push
git push "$PUSH_URL" "$BRANCH"

echo -e "${GREEN}[DONE] Push complete — origin unchanged.${RESET}"
