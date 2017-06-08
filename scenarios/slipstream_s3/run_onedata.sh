#!/bin/bash

export PROVIDER_TYPE='s3'
# Scenario has to be defined before the source
SCENARIO_NAME="slipstream$PROVIDER_TYPE"

source ../slipstreamlib/lib.sh

set_onecomp_type "$@"
set_ss_params
set_s3_env_vars
set_docker_image_id
wait_onezone_ready

if [ "$ONECOMP_TYPE" == "zone" ]; then
    # we should be in the script's directory
    export AUTH_PATH=$(pwd)/auth.config
    HNFEDID_APP_ID=$(ss-get hnfedid-app-id)
    HNFEDID_APP_SECRET=$(ss-get hnfedid-app-secret)
    HNFEDID_URL=$(ss-get hnfedid-url)
    sed -i -e 's/HNFEDID_APP_ID/'$HNFEDID_APP_ID'/' $AUTH_PATH
    sed -i -e 's/HNFEDID_APP_SECRET/'$HNFEDID_APP_SECRET'/' $AUTH_PATH
    sed -i -e 's/HNFEDID_URL/'$HNFEDID_URL'/' $AUTH_PATH
fi

main "$@"
