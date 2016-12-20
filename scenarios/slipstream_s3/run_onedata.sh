#!/bin/bash

# SlipStream Parameters
export PROVIDER_TYPE='nfs'
export ADMIN_USERNAME='admin'
export ADMIN_PASSWORD=`ss-random`
ss-set admin-username "${ADMIN_USERNAME}"
ss-set admin-password "${ADMIN_PASSWORD}"

export S3_HOSTNAME `ss-get ss-hostname`
export S3_ACCESS_KEY `ss-get ss-access-key`
export S3_SECRET_KEY `ss-get ss-secret-key`
export S3_BUCKET `ss-get ss-bucket`

# Scenario has to be defined before the source
SCENARIO_NAME='slipstreams3'

source ../../bin/run_onedata.sh 

clean_scenario() {
	: # pass
}

main "$@"
