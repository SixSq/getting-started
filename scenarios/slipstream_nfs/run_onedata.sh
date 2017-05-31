#!/bin/bash

export PROVIDER_TYPE='nfs'
# Scenario has to be defined before the source
SCENARIO_NAME="slipstream$PROVIDER_TYPE"

source ../slipstreamlib/lib.sh

set_onecomp_type "$@"
set_ss_params
set_docker_image_id

main "$@"
