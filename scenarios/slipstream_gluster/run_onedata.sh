#!/bin/bash -xe

# SlipStream Parameters
export PROVIDER_TYPE='gluster'
export ADMIN_USERNAME='admin'
export ADMIN_PASSWORD=`ss-random`
ss-set admin-username "${ADMIN_USERNAME}"
ss-set admin-password "${ADMIN_PASSWORD}"

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
attach_gluster_volume

# Docker compose project name.
SCENARIO_NAME='slipstreamgluster'

source ../../bin/run_onedata.sh

clean_scenario() {
    : # pass
}

main "$@"
