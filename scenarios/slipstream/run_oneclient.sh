#!/bin/bash

set -x
set -e

export ONECOMP_TYPE=client

source ./lib.sh

set_docker_image_id

export ONECLIENT_AUTHORIZATION_TOKEN=$(ss-get --noblock auth-token)
export PROVIDER_HOSTNAME=$(ss-get --noblock provider-hostname)

if [ -n "$ONECLIENT_AUTHORIZATION_TOKEN" -a -n "$PROVIDER_HOSTNAME" ]; then
    main $@ -p $PROVIDER_HOSTNAME -t $ONECLIENT_AUTHORIZATION_TOKEN
fi
