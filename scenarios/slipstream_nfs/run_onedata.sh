#!/bin/bash

# SlipStream Parameters
export PROVIDER_TYPE='nfs'
export ADMIN_USERNAME='admin'
export ADMIN_PASSWORD=`ss-random`
ss-set admin-username "${ADMIN_USERNAME}"
ss-set admin-password "${ADMIN_PASSWORD}"

# Scenario has to be defined before the source
SCENARIO_NAME='slipstreamnfs'

source ../../bin/run_onedata.sh 

clean_scenario() {
	: # pass
}

main "$@"
