#!/bin/bash

export ONECOMP_TYPE=provider

scenarios="s3|gluster|s3-gluster"
if [ echo $1 | grep -Eq "^($scenarios)$" ]; then
    echo "First argument should be one of: $scenarios"
    exit 1
fi
export PROVIDER_TYPE=$1
shift 1
# Scenario has to be defined before the source
SCENARIO_NAME="slipstream$PROVIDER_TYPE"

source ./lib.sh

cp docker_compose-oneprovider_$PROVIDER_TYPE.yml \
    docker_compose-oneprovider.yml

set_ss_params

case $PROVIDER_TYPE in
    "s3")
        configure_s3
        ;;
    "gluster")
        configure_gluster
        ;;
    "s3-gluster")
        configure_s3
        configure_gluster
        ;;
    *)
        echo "Unknown provider type: $PROVIDER_TYPE"
        exit 1
        ;;
esac

set_docker_image_id

wait_onezone_ready

main --provier $@
