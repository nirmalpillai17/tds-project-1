#!/usr/bin/bash

# Check arguments
if [ $# -lt 4 ]; then
	echo -e "Usage: search_users.sh \n\t\t<location> \
			\n\t\t<min_followers>\n\t\t<output_file>.json \
							\n\t\t<github_api_token>"
	exit -1
fi

# Create output file
echo '[' > $3

# Talk to the API

curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $4" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/search/users?q=location%3A${1}+followers%3A%3E${2}&page=[1-12]" >> $3

echo ',' >> $3


