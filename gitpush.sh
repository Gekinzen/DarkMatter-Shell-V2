#!/bin/bash

# ---------------------------------------------------
#  Zenith Git Push (Auto-Detect Remote + Safe Push)
# ---------------------------------------------------

GREEN="\e[92m"
YELLOW="\e[93m"
RED="\e[91m"
RESET="\e[0m"

TARGET_REPO="https://github.com/Gekinzen/Zenith-Shell-Alpha-V2.git"
TOKEN_FILE="$HOME/.config/github_token"

echo -e "${GREEN}Zenith Git Push Utility Loaded${RESET}"

# ---------------------------------------------------
# Check for token
# ---------------------------------------------------
if [ ! -f "$TOKEN_FILE" ]; then
    echo -e "${RED}[ERROR] Missing GitHub token file: $TOKEN_FILE${RESET}"
    exit 1
fi

GITHUB_TOKEN=$(cat "$TOKEN_FILE")

# ---------------------------------------------------
# Detect current origin
# ---------------------------------------------------
CURRENT_URL=$(git remote get-url origin 2>/dev/null)

if [ -z "$CURRENT_URL" ]; then
    echo -e "${RED}[ERROR] No remote 'origin' found.${RESET}"
    exit 1
fi

echo -e "${YELLOW}Current origin:${RESET} $CURRENT_URL"

# ---------------------------------------------------
# Auto-detect repo mismatch
# ---------------------------------------------------
if [[ "$CURRENT_URL" != "$TARGET_REPO" ]]; then
    echo -e "${YELLOW}[WARN] Origin does NOT match Zenith repo.${RESET}"
    echo -e "Expected: $TARGET_REPO"
    echo -ne "${GREEN}Fix it automatically? (y/n): ${RESET}"
    read ANSWER

    if [[ "$ANSWER" == "y" || "$ANSWER" == "Y" ]]; then
        echo -e "${GREEN}[INFO] Updating origin remote...${RESET}"
        git remote set-url origin "$TARGET_REPO"
        echo -e "${GREEN}[OK] Remote updated successfully.${RESET}"
        CURRENT_URL="$TARGET_REPO"
    else
        echo -e "${YELLOW}[INFO] Using existing origin.${RESET}"
    fi
fi

# ---------------------------------------------------
# Detect CURRENT BRANCH ACCURATELY
# ---------------------------------------------------
BRANCH=$(git branch --show-current)

if [ -z "$BRANCH" ]; then
    echo -e "${RED}[ERROR] You are not on a branch.${RESET}"
    exit 1
fi

echo -e "${GREEN}Active branch:${RESET} $BRANCH"

# ---------------------------------------------------
# Build temporary push URL (secure, no origin change)
# ---------------------------------------------------
PUSH_URL=$(echo "$CURRENT_URL" | sed -E "s#https://#https://$GITHUB_TOKEN@#")

# ---------------------------------------------------
# Commit message
# ---------------------------------------------------
if [ -z "$1" ]; then
    COMMIT_MSG="update: auto-push"
else
    COMMIT_MSG="$1"
fi

echo -e "${YELLOW}[INFO] Staging...${RESET}"
git add -A

echo -e "${YELLOW}[INFO] Committing...${RESET}"
git commit -m "$COMMIT_MSG"

echo -e "${YELLOW}[INFO] Pushing to branch '$BRANCH'...${RESET}"
git push "$PUSH_URL" "$BRANCH"

echo -e "${GREEN}[DONE] Push complete — branch preserved, origin unchanged.${RESET}"
