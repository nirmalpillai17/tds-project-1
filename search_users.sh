#!/usr/bin/bash

# Check arguments
if [ $# -lt 2 ]; then
	echo "Usage: search_users <location> <followers>"
	exit -1
fi

# Create output file
touch users.json

# Make API requests
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/search/users?q=location%3A${1}+followers%3A%3E${2}&page=[1-12]" >> users.json
