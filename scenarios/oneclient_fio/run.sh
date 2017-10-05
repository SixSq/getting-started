#!/usr/bin/env bash

# samba
mkdir -p /run/samba
smbd
nmbd

# nfs
rpcbind
rpc.nfsd
exportfs -ar
rpc.mountd
rpc.nfsd
rpc.statd

# add the env for the benchmarks
cat >>/root/env <<EOF
IOPING_PATH=$IOPING_PATH
IOPING_COUNT=${IOPING_COUNT-:5}
IOPING_DEADLINE=${IOPING_DEADLINE-:60}
IOPING_SIZE=${IOPING_SIZE-:"1m"}
CLOUD=$CLOUD
SERVICE_OFFER=${SERVICE_OFFER-:"service-offer/unknown"}
NUVLA_KEY=$NUVLA_KEY
NUVLA_SECRET=$NUVLA_SECRET
EOF

# add custom line to start cron benchmarks
cron

oneclient -f "$@"
