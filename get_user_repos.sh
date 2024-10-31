#!/bin/bash

# Check user arguments
if [ $# -lt 3 ]; then
	echo "Usage: get_user_repos.sh \n\t\t<input_file>.json \
				\n\t\t<output_file>.json \n\t\t<github_api_token>"
	exit -1
fi

# This function dumps headers into .headers file
# We will keep it there, helps in debugging
make_request () {
	echo "$(curl -L -D .headers \
	  -H "Accept: application/vnd.github+json" \
	  -H "Authorization: Bearer $5" \
	  -H "X-GitHub-Api-Version: 2022-11-28" \
	  "https://api.github.com/users/${1//\"/}/repos?per_page=100&page=[${2}-${3}]")," >> $4
}

# Create output file
echo '{' > user_repos.json

# Talk to ma API
for name in $(jq .[].items[].login $1); do
	# login field is not part of the API response,
	# so adding it manually
	echo "${name}: [" >> $2

	# Making the first first request
	make_request $name 1 1 user_repos.json $3
	
	# Find the number of pages we have for this endpoint
	last=$(grep "link" .headers | sed 's/link:.*page=\(.*\)>; rel="last".*/\1/')
	
	# The below safety check is probably not required
	# Adding it anyway!
	if [ -z $last ]; then break; fi

	# Get the remaining pages, if any
	make_request $name 2 $last $2 $3

	# Complete json srtucture
	echo '[]],' >> $2

	# sleep 1   # Let ma API take a breath!
	sleep 0.5   # Too slow, maybe half-a-breath!
done

# Complete the json structure
echo '"": [] }' >> $2

# Clean up the json
temp=$(mktemp)
jq .[0:-1] $2 > $temp
cat $temp > $2
