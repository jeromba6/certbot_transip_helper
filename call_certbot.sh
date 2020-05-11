#!/bin/bash

EMAIL=me@exmple.com
DOMAIN=example.com

SERVER=https://acme-v02.api.letsencrypt.org/directory
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
