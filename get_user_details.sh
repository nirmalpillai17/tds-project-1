#!/bin/bash

# Check arguments
if [ $# -lt 2 ]; then
	echo "Usage: get_usernames <file_name>.json <github_api_token>"
	exit -1
fi

# Create output file
echo '[' > user_details.json

# Talk to API
for name in $(jq .[].items[].login $1); do
	curl -L \
	  -H "Accept: application/vnd.github+json" \
	  -H "Authorization: Bearer $2" \
	  -H "X-GitHub-Api-Version: 2022-11-28" \
	  "https://api.github.com/users/${name//\"/}" >> user_details.json

	echo ',' >> user_details.json

	sleep 0.5  # Let GitHub API take a breath!
done

# Complete the json structure
echo '{} ]' >> user_details.json

# Clean up the json
temp=$(mktemp)
jq .[0:-1] user_details.json > $temp
cat $temp > user_details.json
