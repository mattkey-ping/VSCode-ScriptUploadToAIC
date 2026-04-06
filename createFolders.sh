#!/bin/bash
# Name: createFolders.sh
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
#   Create directories used by scriptUploadToAIC in folderMappings.json
#
# Required Prerequisites:
#   jq - brew install jq 
#   chmod 775 createFolders.sh
#
# Usage:
#   ./createFolders.sh folderMappings.json
#

## get args
if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is not installed - brew install jq"
    exit 1
fi
if [ -z "$1" ]; then
    echo "Error: Missing folderMappings.json file"
    echo "Usage: ./createFolders.sh folderMappings.json"
    exit 1
fi
mappingsFile="$1"
if [[ ! -f "$mappingsFile" ]]; then
    echo "Error: File $mappingsFile not found."
    exit 1
fi

## read folderMappings.json
grep -v "^//" "$mappingsFile" | jq -c '.[]' | while read -r property; do
    folder=$(echo "$property" | jq -r '.folder')
    context=$(echo "$property" | jq -r '.context')

    if [[ -n "$folder" && -n "$context" ]]; then

        ## group SAML folders
        if [[ "$context" == SAML2_* ]]; then
            folder="SAML/$folder"
        ## group OAuth folders
        elif [[ "$context" == OAUTH2_* ]]; then
            folder="OAuth/$folder"
        ## group OIDC folders
        elif [[ "$context" == OIDC_CLAIMS ]]; then
            folder="OIDC/Claims"
        fi

        ## create directory for each object
        if [[ ! -d "$folder" ]]; then
            mkdir -p "$folder"
            echo "Directory Created: $folder"
        else
            echo "Directory Exists: $folder"
        fi
    fi
done
echo "Finished."