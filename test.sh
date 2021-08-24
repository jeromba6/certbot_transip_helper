#!/bin/bash

# Example:
# SUB_DOMAIN=www DOMAIN_NAME=example.com ./test.sh

if [ -z "${DOMAIN_NAME}" ]
then
   echo "Environment variable DOMAIN_NAME is not set"
   exit 1
fi

VALIDATION="Some random string to test"

# Next should be in 1 line so the variables are passed to the command
# It creates a DNS record like '_acme-challenge  60  TXT "Some random string to test"'
DOMAIN="$DOMAIN_NAME" CERTBOT_VALIDATION="$VALIDATION" ./certbot_transip_helper.py

# Go check your transip dashboard and see if it's there
