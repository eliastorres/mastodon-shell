#!/bin/bash
# 
# A simple script to post to Mastodon from command line
# Elias Torres @donelias@mastodon.cr
# License: https://www.gnu.org/licenses/gpl-3.0.html

# Create an application at:
# https://mastodon.example/settings/applications
# and get the ACCESS_TOKEN

ACCESS_TOKEN=""
MASTODON_SERVER="mastodon.example.com"
VISIBILITY="public" # "direct", "unlisted"
LANG="en"

# End of configuration

statustext="$@"
header="Authorization: Bearer $ACCESS_TOKEN"
URL="https://$MASTODON_SERVER/api/v1/statuses"

response=$(curl --header "$header" -sS $URL -X POST \
	-d "status=$statustext&language=$LANG&visibility=$VISIBILITY" ) #| jq '.content')

#echo $response
