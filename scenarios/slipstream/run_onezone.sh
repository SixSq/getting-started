#!/bin/bash

set -x
set -e

export ONECOMP_TYPE=zone

source ./lib.sh


set_ss_params
set_docker_image_id

# we should be in the script's directory
export AUTH_PATH=$(pwd)/auth.config

HN_FEDID_CLIENT_INIT_TKN=$(ss-get hn-fedid-token)
HN_FEDID_BASE_URL=$(ss-get hn-fedid-url)
HN_FEDID_CLIENT_ID=$(ss-get hn-fedid-client-id)
HN_TENANT_NAME=$(ss-get hn-tenant-name)

ZONE_NAME=$HN_TENANT_NAME

HN_FEDID_TENANT_URL=$HN_FEDID_BASE_URL/auth/realms/$HN_TENANT_NAME
HN_FEDID_CLIENT_REG_URL=$HN_FEDID_TENANT_URL/clients-registrations/default
HN_FEDID_OID_CONF_URL=$HN_FEDID_TENANT_URL/.well-known/openid-configuration

# Create client in FedID provider and obtain client secret.
# https://keycloak.gitbooks.io/documentation/securing_apps/topics/client-registration.html
JSON_PATH=$(pwd)/client.json
OZ_HOST=$(ss-get hostname)
sed -i -e 's|OZ_HOST|'$OZ_HOST'|' \
    -i -e 's|HN_FEDID_CLIENT_ID|'$HN_FEDID_CLIENT_ID'|' \
    $JSON_PATH
RESP=$(curl -sSf -X POST \
           -d @$JSON_PATH \
           -H "Content-Type:application/json" \
           -H "Authorization: bearer $HN_FEDID_CLIENT_INIT_TKN" \
           "$HN_FEDID_CLIENT_REG_URL")
HN_FEDID_CLIENT_SECRET=$(echo $RESP | jq -r '.secret')

sed -i -e 's|HN_FEDID_CLIENT_ID|'$HN_FEDID_CLIENT_ID'|' $AUTH_PATH
sed -i -e 's|HN_FEDID_CLIENT_SECRET|'$HN_FEDID_CLIENT_SECRET'|' $AUTH_PATH
sed -i -e 's|HN_FEDID_OID_CONF_URL|'$HN_FEDID_OID_CONF_URL'|' $AUTH_PATH

set +e
main --zone --name $ZONE_NAME $@
set -e

# wait_started
