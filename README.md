# mastodon-shell
Shell scripts to post to a Mastodon Account

# Usage
* Posting just text:
`./mastodon-shell-post-text.sh "Hello world!"`

* Posting text with an image:

`./mastodon-shell-post-media.sh "Look at this image with ALT text #hashtag" "image1.jpg" "Description for image 1"`

* Posting text with two images:

`./mastodon-shell-post-media.sh "Look at those images with ALT text #hashtag" "image1.jpg" "Description for image 1" "image2.jpg" "Description for image 2"`

# Configuration

```
Mastodon API documentation:
* https://docs.joinmastodon.org/methods/statuses/
# Create an application at:
## https://mastodon.example/settings/applications
#ACCESS_TOKEN=""
## FQDN of the mastodon server/instance
#MASTODON_SERVER="mastodon.example.com"
## visibility: String. Sets the visibility of the posted status to public, unlisted, private, direct.
#VISIBILITY="unlisted"
## language: String. ISO 639 language code for this status.
#LANG="en"
## End of configuration
```
