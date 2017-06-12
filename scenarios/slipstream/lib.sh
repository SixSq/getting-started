#!/bin/bash

wait_onezone_ready() {
    [ "$ONECOMP_TYPE" == "provider" ] || return 0
    ss-get --timeout 1800 onezone-ready
}

set_onecomp_type() {
    # CLI input is expected.
    export ONECOMP_TYPE=
    if ( echo "$@" | grep -q -- "provider" ); then
        type=provider
    elif ( echo "$@" | grep -q -- "zone" ); then
        type=zone
    else
        type=client
    fi
    export ONECOMP_TYPE=$type
}

set_ss_params() {
    export ADMIN_USERNAME='admin'
    export ADMIN_PASSWORD=`ss-random`
    ss-set admin-username "${ADMIN_USERNAME}"
    ss-set admin-password "${ADMIN_PASSWORD}"
}

set_docker_image_id() {
    provider_file=docker_compose-one${ONECOMP_TYPE}_${PROVIDER_TYPE}.yml
    if [ -f "$provider_file" ]; then
        cp $provider_file docker_compose-oneprovider.yml
    fi
    docker_id=`ss-get --noblock docker-image-id`
    if [ -n "$docker_id" ]; then
        sed -i -e "s|image:.*$|image: $docker_id|" \
            docker-compose-one${ONECOMP_TYPE}.yml
    fi
}

configure_s3() {
    [ "$ONECOMP_TYPE" == "provider" ] || return 0

    export S3_HOSTNAME="`ss-get s3-hostname`"
    export S3_ACCESS_KEY="`ss-get s3-access-key`"
    export S3_SECRET_KEY="`ss-get s3-secret-key`"
    export S3_BUCKET="`ss-get s3-bucket`"

    if [ "$S3_HOSTNAME" == "sos.exo.io" ]; then
        sed -i -e 's/#signatureVersion: 2/signatureVersion: 2/' \
            docker-compose-oneprovider.yml
    fi
}

configure_gluster() {
    [ "$ONECOMP_TYPE" == "provider" ] || return 0

    export ONEPROVIDER_DATA_DIR=/mnt/gluster-onedata

    GL_VERSION=`ss-get gl-version`
    GL_MASTER_VOL=`ss-get gl-master-vol`
    add-apt-repository -y ppa:gluster/glusterfs-$GL_VERSION
    apt-get update
    apt-get install -y glusterfs-client
    mkdir -p $ONEPROVIDER_DATA_DIR
    mount -t glusterfs $GL_MASTER_VOL $ONEPROVIDER_DATA_DIR
}

source ../../bin/run_onedata.sh

clean_scenario() {
    : # pass
}
