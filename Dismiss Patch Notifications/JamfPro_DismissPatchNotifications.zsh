#!/bin/zsh

# Color variables
boldred='\033[1;31m'
green='\033[0;32m'
yellow='\033[0;33m'
boldblue='\033[1;34m'
# Clear the color after that
clear='\033[0m'

## Ask for Jamf Pro instance
echo "Enter your Jamf Cloud instance name: "
read jci
echo

url="https://$jci.jamfcloud.com"
echo "Jamf Pro instance is: ${boldblue}$url${clear} \n"

echo -e "${boldred}WARNING: This script will dismiss all patch update notifications!${clear}"
echo -e "${yellow}Press ctrl+c to cancel.${clear} \n"

# Ask for username and password
echo "Enter your Jamf Pro username: "    # Prompt for entering username 
read username
echo

echo -n "Enter your Jamf Pro password: " # Prompt for entering password 
read -s password    # Read password by suppressing it using -s option
echo

#Variable declarations
bearerToken=""
tokenExpirationEpoch="0"

# Create temporary working directory and cd into it
tmpDir=$(mktemp -d)
cd $tmpDir

# API call to generate Bearer Token
getBearerToken() {
	response=$(curl -s -u "$username":"$password" "$url"/api/v1/auth/token -X POST)
	bearerToken=$(echo "$response" | plutil -extract token raw -)
	tokenExpiration=$(echo "$response" | plutil -extract expires raw - | awk -F . '{print $1}')
	tokenExpirationEpoch=$(date -j -f "%Y-%m-%dT%T" "$tokenExpiration" +"%s")
}

## MAIN FUNCTION ##
# Receive all "PATCH_UPDATE" notification IDs
dismissNotifications() {
    curl -X 'GET' \
    "$url/api/v1/notifications" \
    -H "accept: application/json" \
    -H "Authorization: Bearer ${bearerToken}" | \
    jq 'map(select(.type == "PATCH_UPDATE").id)' | \
    cut -d '"' -f2 | sed 's/[][]//g' | grep '\S' >> notif-ids.txt # Parse output, format it and save as file

    # Check, if notif-ids.txt is empty or not
    if [ -s notif-ids.txt ]; then
        # Read lines containing notification IDs from file and loop through them to dismiss
        while IFS="" read -r p || [ -n "$p" ]
        do
            curl -X -o- 'DELETE' \
            -H "Authorization: Bearer ${bearerToken}" \
            --url "$url/api/v1/notifications/PATCH_UPDATE/$p"
        done < notif-ids.txt
    else
        # The file is empty.
        echo "No notifications found. Skipping..."
        invalidateToken
        curl -s -H "Authorization: Bearer ${bearerToken}" $url/api/v1/jamf-pro-version -X GET
    fi
}

# Function to check for token expiration
checkTokenExpiration() {
    nowEpochUTC=$(date -j -f "%Y-%m-%dT%T" "$(date -u +"%Y-%m-%dT%T")" +"%s")
    if [[ tokenExpirationEpoch -gt nowEpochUTC ]]
    then
        echo "Token valid until the following epoch time: " "$tokenExpirationEpoch"
    else
        #echo "No valid token available, getting new token"
        getBearerToken
    fi
}

# Function to invalidate the active token
invalidateToken() {
	responseCode=$(curl -w "%{http_code}" -H "Authorization: Bearer ${bearerToken}" $url/api/v1/auth/invalidate-token -X POST -s -o /dev/null)
	if [[ ${responseCode} == 204 ]]
	then
		echo "${green}Token successfully invalidated${clear} \n"
		bearerToken=""
		tokenExpirationEpoch="0"
	elif [[ ${responseCode} == 401 ]]
	then
		echo "${green}Token already invalid${clear} \n"
	else
		echo "${boldred}An unknown error occurred invalidating the token${clear} \n"
        exit 5
	fi
}

## CALLING ALL THE FUNCTIONS ##
checkTokenExpiration
curl -s -H "Authorization: Bearer ${bearerToken}" $url/api/v1/jamf-pro-version -X GET

dismissNotifications

invalidateToken
curl -s -H "Authorization: Bearer ${bearerToken}" $url/api/v1/jamf-pro-version -X GET

exit 0
