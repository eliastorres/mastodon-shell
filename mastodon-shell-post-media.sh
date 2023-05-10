#!/bin/bash
# 
# A simple script to post to Mastodon from command line
# Elias Torres @donelias@mastodon.cr
# License: https://www.gnu.org/licenses/gpl-3.0.html
# Please use, improve, remix, fork
# and don't forget to share and contribute 

# Dependencies:
# - curl  https://curl.se/
# - file  https://www.darwinsys.com/file/
# - jq    https://stedolan.github.io/jq/
# Debian:
#   apt install curl file jq

# Usage:
# mastodon-shell-post-media.sh "Status text" "media1.jpg" "Alt1" ["media2.jpg"] ["Alt2"]

# Mastodon API documentation:
# https://docs.joinmastodon.org/methods/statuses/
# https://docs.joinmastodon.org/methods/media/

# Strategy:
# 1. Images are uploaded first, server returns an ID for each one.
# 2. Then we post a status referring to those IDs in an array, 4 max.

# Create an application at:
# https://mastodon.example/settings/applications
ACCESS_TOKEN=""
# FQDN of the mastodon server/instance
MASTODON_SERVER="mastodon.example.com"
# visibility: String. Sets the visibility of the posted status to public, unlisted, private, direct.
VISIBILITY="unlisted"
# language: String. ISO 639 language code for this status.
LANG="en"

# Optionally move config variables to a separate file
#CONFIG_FILE=~/.mastodon-shell-config.conf
#source $CONFIG_FILE || { echo "Config file $CONFIG_FILE not found or not readable" >&2 ; exit 1 ; }
# TODO: Validate config
# End of configuration

# status: REQUIRED String. The text content of the status.
# If media_ids is provided, this becomes optional.
# Attaching a poll is optional while status is provided.
# $@ are all parameters of this script
statustext=$1

# Image 1 and its alt description. # Mastodon API documentation:
# https://docs.joinmastodon.org/methods/statuses/
# Create an application at:
# https://mastodon.example/settings/applications
ACCESS_TOKEN=""
# FQDN of the mastodon server/instance
MASTODON_SERVER="mastodon.example.com"
# visibility: String. Sets the visibility of the posted status to public, unlisted, private, direct.
VISIBILITY="unlisted"
# language: String. ISO 639 language code for this status.
LANG="en"
file="$2"
description="$3"

# Check if the file is readable and is an image
test -f "$file" || { echo "Media file $file not found or not readable" >&2 ; exit 1 ; }
file --mime-type "$file" | grep -q image || { echo "Media file $file looks like is not an image based on command file(1)" >&2 ; exit 1 ; }

header="Authorization: Bearer $ACCESS_TOKEN"
URL="https://$MASTODON_SERVER/api/v2/media"

POST_DATA="status=$statustext&language=$LANG&visibility=$VISIBILITY"

_media_response=$(curl --header "$header" -sS $URL -X POST \
        -F "description=$description" -F "file=@$file" )
_id=$(echo $_media_response | jq '.id' | sed s'/"//g')

POST_DATA="$POST_DATA&media_ids[]=$_id"

# Optionally add a second file, arguments 4 and 5
if test -f "$4" && file --mime-type "$4" | grep -q image; then
        description="$5"
        _media_response=$(curl --header "$header" -sS $URL -X POST \
                -F "description=$description" -F "file=@$4" )
                _id2=$(echo $_media_response | jq '.id' | sed s'/"//g')
         POST_DATA="$POST_DATA&media_ids[]=$_id2"
fi
# TODO: do the same with more optional parameters, Mastodon accepts up to 4 media files.

# API endpoint to post status
URL2="https://$MASTODON_SERVER/api/v1/statuses"
response=$(curl --header "$header" -sS $URL2 -X POST \
        -d "$POST_DATA" | jq '.content')
# TODO: do something with the JSON output
#echo $response
