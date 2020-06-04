#!/bin/ash

# The variables EMAIL and DOMAIN should be set in the environment
# EMAIL=user@example.com
# DOMAIN=example.com

mkdir -p ~/certs

if [ -z "${EMAIL}"]
then
   echo "Environment variable EMAIL is not set"
   exit 1
fi
if [ -z "${DOMAIN}"]
then
   echo "Environment variable DOMAIN is not set"
   exit 1
fi

# Choose staging or live, after staging forcing live can be done by adding: --force-renewal
if [ "${CERTBOT_ENV}" == 'live' ]
then
   # Live
   SERVER=https://acme-v02.api.letsencrypt.org/directory
else
   # Staging
   SERVER=https://acme-staging-v02.api.letsencrypt.org/directory
fi

if [ "${FORCE_CERT_RENEW}" == 'True' ]
then
    FORCE_RENEW='--force-renewal'
fi
certbot -n --manual-public-ip-logging-ok \
        --server $SERVER certonly \
        --agree-tos \
        --email $EMAIL \
        --manual --preferred-challenges=dns \
        --manual-auth-hook /opt/certbot/certbot_transip_helper.py \
        --manual-cleanup-hook /opt/certbot/certbot_transip_helper.py \
        --config-dir ~/certs \
        --work-dir ~/certs \
        --logs-dir ~/certs \
        -d "*.$DOMAIN" ${FORCE_RENEW}
