#!/bin/bash

export PROVIDER_TYPE='gluster'
# Scenario has to be defined before the source
SCENARIO_NAME="slipstream$PROVIDER_TYPE"

source ../slipstreamlib/lib.sh

set_onecomp_type "$@"
set_ss_params
attach_gluster_volume
set_docker_image_id

main "$@"
