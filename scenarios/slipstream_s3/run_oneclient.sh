#!/bin/bash

source ../slipstreamlib/lib.sh

set_onecomp_type "$@"
set_docker_image_id

main "$@"
