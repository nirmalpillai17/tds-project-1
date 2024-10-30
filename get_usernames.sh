#!/bin/bash

# Check arguments
if [ $# -lt 1 ]; then
	echo "Usage: get_usernames <file_name>.json"
	exit -1
fi

# Parse json
jq .items.[].items.[].login $1 > usernames.json
