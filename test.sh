#!/bin/bash

DOMAIN="gemert.net"
VALIDATION="Some random string to test"

# Next should be in 1 line so the variables are passed to the command
CERTBOT_DOMAIN="$DOMAIN" CERTBOT_VALIDATION="$VALIDATION" ./certbot_transip_helper.py