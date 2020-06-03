#!/bin/bash

EMAIL=me@exmple.com
DOMAIN=example.com

# Choose staging or live, after staging forcing live can be done by adding: --force-renewal
# Live
# SERVER=https://acme-v02.api.letsencrypt.org/directory
# Staging
SERVER=https://acme-staging-v02.api.letsencrypt.org/directory

certbot -n --manual-public-ip-logging-ok \
        --server $SERVER certonly \
        --agree-tos \
        --email $EMAIL \
        --manual --preferred-challenges=dns \
        --manual-auth-hook $PWD/certbot_transip_helper.py \
        --manual-cleanup-hook $PWD/certbot_transip_helper.py \
        --config-dir $PWD/Transip \
        --work-dir $PWD/Transip \
        --logs-dir $PWD/Transip \
        -d "*.$DOMAIN"
        # Force live renewal
        # -d "*.$DOMAIN" --force-renewal