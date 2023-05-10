#!/bin/bash
# 
# A simple script to post to Mastodon from command line
# © 2023 Elias Torres @donelias@mastodon.cr
# License: https://www.gnu.org/licenses/gpl-3.0.html

# Requirements:
# - curl

# Create an application at:
# https://mastodon.example/settings/applications
# and get the ACCESS_TOKEN

# Optionally move config variables to a separate file
#CONFIG_FILE=mastodon-shell-config.sh
#source $CONFIG_FILE || { echo "Config file $CONFIG_FILE not found or not readable" >&2 ; exit 1 ; }
# TODO: Validate config

# Mastodon API documentation:
# https://docs.joinmastodon.org/methods/statuses/
ACCESS_TOKEN=""
# FQDN of the mastodon server/instance
MASTODON_SERVER="mastodon.example.com"
# visibility: String. Sets the visibility of the posted status to public, unlisted, private, direct.
VISIBILITY="unlisted"
# language: String. ISO 639 language code for this status.
LANG="en"
# End of configuration

# status: REQUIRED String. The text content of the status.
# If media_ids is provided, this becomes optional.
# Attaching a poll is optional while status is provided.
# $@ are all parameters of this script
STATUS_TEXT="$@"

header="Authorization: Bearer $ACCESS_TOKEN"
URL="https://$MASTODON_SERVER/api/v1/statuses"

response=$(curl --header "$header" -sS $URL -X POST \
	-d "language=$LANG&visibility=$VISIBILITY&status=$STATUS_TEXT" )

# TODO: do something with the JSON output
#echo $response | jq '.content'
