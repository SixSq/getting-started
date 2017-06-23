#!/bin/bash

export SCENARIO_NAME=slipstream

wait_onezone_ready() {
    ss-get --timeout 1800 onezone-ready
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
    export ONEPROVIDER_DATA_DIR=/mnt/gluster-onedata

    GL_VERSION=`ss-get gl-version`
    GL_MASTER_VOL=`ss-get gl-master-vol`
    add-apt-repository -y ppa:gluster/glusterfs-$GL_VERSION
    apt-get update
    apt-get install -y glusterfs-client
    mkdir -p $ONEPROVIDER_DATA_DIR
    mount -t glusterfs $GL_MASTER_VOL $ONEPROVIDER_DATA_DIR
}

if [ "$ONECOMP_TYPE" == "client" ]; then
    source ../../bin/run_oneclient.sh
else
    source ../../bin/run_onedata.sh
fi

clean_scenario() {
    : # pass
}

wait_started() {
    msg="Congratulations! one$ONECOMP_TYPE has been successfully started"
    while $(! docker logs one$ONECOMP_TYPE-1 | grep -q $msg); do
        sleep 3
    done
}
