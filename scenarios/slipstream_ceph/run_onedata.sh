#!/bin/bash

# SlipStream Parameters
export PROVIDER_TYPE='nfs'
export ADMIN_USERNAME='admin'
export ADMIN_PASSWORD=`ss-random`
ss-set admin-username "${ADMIN_USERNAME}"
ss-set admin-password "${ADMIN_PASSWORD}"

export CEPH_USERNAME=`ss-get ceph-username`
export CEPH_KEY=`ss-get ceph-key`
export CEPH_MONITOR_HOSTNAME=`ss-get ceph-monitor-hostname`
export CEPH_CLUSTER_NAME=`ss-get ceph-cluster-name`

# Scenario has to be defined before the source
SCENARIO_NAME='slipstreamceph'

source ../../bin/run_onedata.sh 

clean_scenario() {
	: # pass
}

main "$@"
