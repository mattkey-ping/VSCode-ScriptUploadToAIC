#!/bin/bash
# Name: installBinding.sh
# Version: 2026-04-30
# Author: Matt Key, @mattkey-ping
#
# Disclaimer:
# The sample code described herein is provided on an "as is" basis, without warranty of any kind, to the fullest extent permitted by law. The Author(s) nor Ping Identity does not warrant or guarantee the individual success developers may have in implementing the sample code on their development platforms or in production configurations.
# The Author(s) and Ping Identity does not warrant, guarantee or make any representations regarding the use, results of use, accuracy, timeliness or completeness of any data or information relating to the sample code. The Author(s) and Ping Identity disclaims all warranties, expressed or implied, and in particular, disclaims all warranties of merchantability, and warranties related to the code, or any service or software related thereto.
# The Author(s) and Ping Identity shall not be liable for any direct, indirect or consequential damages or costs of any type arising out of any action taken by you or others related to the sample code.
# This sample code is not covered by any Ping Identity Service Level Agreements.
# 
# Description:
#   simlink and modify keybinding.json into .vscode folder
#   Create directories used by scriptImportToAIC in folderMappings.json
#
# Required Prerequisites:
#   jq - brew install jq 
#
# Usage:
#   ./installBinding.sh
#

TARGET_DIR="$HOME/Library/Application Support/Code/User"
TARGET_FILE="$TARGET_DIR/keybindings.json"
LINK_NAME="./keybindings.json"
CONTENT='    {
        "key": "cmd+u",
        "command": "workbench.action.tasks.runTask",
        "args": "Upload script to AIC",
        "when": "editorTextFocus"
    }'
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
MAPPINGSFILE="$SCRIPT_DIR/folderMappings.json"

if [[ ! -f "$MAPPINGSFILE" ]]; then
    echo "Error: $MAPPINGSFILE not found."
    exit 1
fi

if [ -f "./scriptUploadToAIC" ]; then
    chmod 775 "./scriptUploadToAIC"
fi

if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is not installed - brew install jq"
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: $TARGET_DIR not found - look for 'Application Support/Code/User' and modify TARGET_DIR variable in script."
    exit 1
fi

if [ ! -f "$TARGET_FILE" ]; then
    touch "$TARGET_FILE"
fi

if [ ! -L "$LINK_NAME" ]; then
    ln -s "$TARGET_FILE" "$LINK_NAME"
fi

## Create Keybindings file and add keybinding
# Check if file is empty or just whitespace
if [ ! -s "$TARGET_FILE" ] || [[ -z $(grep '[^[:space:]]' "$TARGET_FILE") ]]; then
    # IF NOT copy full JSON array to file
    printf "[\n%s\n]\n" "$CONTENT" > "$TARGET_FILE"
else
    # IF contains content, add object to array
    if ! grep -q "Upload script to AIC" "$TARGET_FILE"; then
        sed '$d' "$TARGET_FILE" > "$TARGET_FILE.tmp"
        printf ",\n%s\n]\n" "$CONTENT" >> "$TARGET_FILE.tmp"
        mv "$TARGET_FILE.tmp" "$TARGET_FILE"
        echo "Keybinding added."
    else
        echo "Keybinding already exists."
    fi
fi

## Create directories for scriptImportToAIC
grep -v "^//" "$MAPPINGSFILE" | jq -c '.[]' | while read -r property; do
    folder=$(echo "$property" | jq -r '.folder')
    context=$(echo "$property" | jq -r '.context')

    if [[ -n "$folder" && -n "$context" ]]; then
        if [[ "$context" == SAML2_* ]]; then
            folder="SAML/$folder"
        elif [[ "$context" == OAUTH2_* ]]; then
            folder="OAuth/$folder"
        elif [[ "$context" == OIDC_CLAIMS ]]; then
            folder="OIDC/Claims"
        fi
        folder=Scripts/"$folder"
        if [[ ! -d "$folder" ]]; then
            mkdir -p "../$folder"
            echo "Directory Created: $folder"
        else
            echo "Directory Exists: $folder"
        fi
    fi
done
echo "Finished."