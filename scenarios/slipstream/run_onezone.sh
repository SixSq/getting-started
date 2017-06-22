#!/bin/bash

export ONECOMP_TYPE=zone

source ./lib.sh

set_ss_params
set_docker_image_id

# we should be in the script's directory
export AUTH_PATH=$(pwd)/auth.config
HN_CLIENT_ID=$(ss-get hn-client-id)
INIT_TKN=$(ss-get hn-fedid-token)
export HNFEDID_URL=$(ss-get hn-fedid-url)

HOST=$(ss-get hostname)


# https://keycloak.gitbooks.io/documentation/securing_apps/topics/client-registration.html
RESP=$(curl -X POST \
                   -d '{ "clientId": "$HN_CLIENT_ID", "rootUrl" : "https://${HOST}", "redirectUris" : ["https://${HOST}/validate_login"] }' \
                   -H "Content-Type:application/json" \
                   -H "Authorization: bearer $INIT_TKN" \
                   "$HNFEDID_URL/clients-registrations/default")

export HNFEDID_APP_SECRET=$(echo $RESP | jq '.secret')


sed -i -e 's|HN_CLIENT_ID|'$HN_CLIENT_ID'|' $AUTH_PATH
sed -i -e 's|HNFEDID_APP_SECRET|'$HNFEDID_APP_SECRET'|' $AUTH_PATH
sed -i -e 's|HNFEDID_URL|'$HNFEDID_URL/.well-known/openid-configuration'|' $AUTH_PATH

main --zone $@


