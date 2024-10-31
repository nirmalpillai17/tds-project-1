#!/bin/bash

# Check arguments
if [ $# -lt 3 ]; then
	echo -e "Usage: get_user_details.sh \n\t\t<input_file>.json \
			\n\t\t<output_file>.json \n\t\t<github_api_token>"
	exit -1
fi

# Create output file
echo '[' > $2

# Talk to API
for name in $(jq .[].items[].login $1); do
	curl -L \
	  -H "Accept: application/vnd.github+json" \
	  -H "Authorization: Bearer $3" \
	  -H "X-GitHub-Api-Version: 2022-11-28" \
	  "https://api.github.com/users/${name//\"/}" >> $2

	echo ',' >> user_details.json

	sleep 0.5  # Let GitHub API take a breath!
done

# Complete the json structure
echo '{} ]' >> $2

# Clean up the json
temp=$(mktemp)
jq .[0:-1] $2 > $temp
cat $temp > $2
