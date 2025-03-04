#!/bin/bash
# 
# A simple script to post to Mastodon from command line
# Elias Torres @donelias@mastodon.cr
# License: https://www.gnu.org/licenses/gpl-3.0.html

# Dependencies:
# curl
# file
# jq

# CONFIG_FILE should contain this:

#ACCESS_TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#MASTODON_SERVER="mastodon.example.net"
#VISIBILITY="public" # public, "direct", "unlisted"
#LANG="es"

CONFIG_FILE=mastodon-shell-config.sh

source $CONFIG_FILE || { echo "Config file $CONFIG_FILE not found or not readable" >&2 ; exit 1 ; }
# End of configuration

# TODO: Validate config

file="$2"

test -f "$file" || { echo "Media file $file not found or not readable" >&2 ; exit 1 ; }
file --mime-type "$file" | grep -q image || { echo "Media file $file looks like is not an image based on command file(1)" >&2 ; exit 1 ; }
description="$3"

header="Authorization: Bearer $ACCESS_TOKEN"
URL="https://$MASTODON_SERVER/api/v2/media"

# Upload media to later attach it to a post
_media_response=$(curl --header "$header" -sS $URL -X POST \
        -F "description=$description" -F "file=@$file" )
_id=$(echo $_media_response | jq '.id' | sed s'/"//g')

if test -f "$4" && file --mime-type "$4" | grep -q image; then
        description="$5"
        _media_response=$(curl --header "$header" -sS $URL -X POST \
                -F "description=$description" -F "file=@$4" )
                _id2=$(echo $_media_response | jq '.id' | sed s'/"//g')
fi

if test -f "$6" && file --mime-type "$6" | grep -q image; then
        description="$7"
        _media_response=$(curl --header "$header" -sS $URL -X POST \
                -F "description=$description" -F "file=@$6" )
                _id3=$(echo $_media_response | jq '.id' | sed s'/"//g')
#       echo $_media_response >&2
fi

if test -f "$8" && file --mime-type "$8" | grep -q image; then
        description="$9"
        _media_response=$(curl --header "$header" -sS $URL -X POST \
                -F "description=$description" -F "file=@$8" )
                _id4=$(echo $_media_response | jq '.id' | sed s'/"//g')
#       echo $_media_response >&2
fi

URL2="https://$MASTODON_SERVER/api/v1/statuses"

statustext="$1"

# Add media parameters if they are set
_media_ids="media_ids[]=$_id"
test ! -z ${_id2+x} && _media_ids="${_media_ids}&media_ids[]=${_id2}"
test ! -z ${_id3+x} && _media_ids="${_media_ids}&media_ids[]=${_id3}"
test ! -z ${_id4+x} && _media_ids="${_media_ids}&media_ids[]=${_id4}"

response=$(curl --header "$header" -sS $URL2 -X POST \
        -d "status=$statustext&language=$LANG&visibility=$VISIBILITY&$_media_ids" )
# DEBUG
#echo $response >&2
