#!/bin/bash

export PROVIDER_TYPE='s3'
# Scenario has to be defined before the source
SCENARIO_NAME="slipstream$PROVIDER_TYPE"

source ../slipstreamlib/lib.sh

set_onecomp_type "$@"
set_ss_params
set_s3_env_vars
set_docker_image_id

main "$@"
