#!/bin/bash

export ONECOMP_TYPE=zone

source ./lib.sh

set_ss_params
set_docker_image_id

# we should be in the script's directory
export AUTH_PATH=$(pwd)/auth.config
HN_CLIENT_ID=$(ss-get hn-client-id)
HNFEDID_APP_SECRET=$(ss-get hnfedid-app-secret)
HNFEDID_URL=$(ss-get hnfedid-url)
sed -i -e 's|HN_CLIENT_ID|'$HN_CLIENT_ID'|' $AUTH_PATH
sed -i -e 's|HNFEDID_APP_SECRET|'$HNFEDID_APP_SECRET'|' $AUTH_PATH
sed -i -e 's|HNFEDID_URL|'$HNFEDID_URL'|' $AUTH_PATH

main --zone $@
