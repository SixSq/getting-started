#!/bin/bash

source ../lib.sh

set_docker_image_id

#export ONECLIENT_AUTHORIZATION_TOKEN=$(ss-get ...)
#export PROVIDER_HOSTNAME=$(ss-get ...)

main "$@ -p $PROVIDER_HOSTNAME -t $ONECLIENT_AUTHORIZATION_TOKEN"
