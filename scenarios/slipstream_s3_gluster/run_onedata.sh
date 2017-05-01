#!/bin/bash

# SlipStream Parameters
export PROVIDER_TYPE='s3-gluster'
export ADMIN_USERNAME='admin'
export ADMIN_PASSWORD=`ss-random`
ss-set admin-username "${ADMIN_USERNAME}"
ss-set admin-password "${ADMIN_PASSWORD}"

export S3_HOSTNAME="`ss-get s3-hostname`"
export S3_ACCESS_KEY="`ss-get s3-access-key`"
export S3_SECRET_KEY="`ss-get s3-secret-key`"
export S3_BUCKET="`ss-get s3-bucket`"

attach_gluster_volume() {
    GL_VERSION=`ss-get gl-version`
    GL_MASTER_VOL=`ss-get gl-master-vol`
    add-apt-repository -y ppa:gluster/glusterfs-$GL_VERSION
    apt-get update
    apt-get install -y glusterfs-client
    mkdir -p $ONEPROVIDER_DATA_DIR
    mount -t glusterfs $GL_MASTER_VOL $ONEPROVIDER_DATA_DIR
}

export ONEPROVIDER_DATA_DIR=/mnt/gluster-onedata

# Scenario has to be defined before the source
SCENARIO_NAME='slipstreams3gluster'

source ../../bin/run_onedata.sh

clean_scenario() {
	: # pass
}

main "$@"

attach_gluster_volume
