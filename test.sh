#!/bin/bash

DOMAIN="gemert.net"
VALIDATION="Some random string to test"

# Next should be in 1 line so the variables are passed to the command
# It creates a DNS record like '_acme-challenge  60  TXT "Some random string to test"'
CERTBOT_DOMAIN="$DOMAIN" CERTBOT_VALIDATION="$VALIDATION" ./certbot_transip_helper.py

# Go check your transip dashboard and see if it's there
