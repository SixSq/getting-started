#!/bin/bash

. /root/env

# run ioping with direct IO (no caching)
ioping -c $IOPING_COUNT -w $IOPING_DEADLINE -s $IOPING_SIZE -B -D $IOPING_PATH > ioping_output

duration_usec=`awk -F' ' '{print $2}' ioping_output`
iops=`awk -F' ' '{print $3}' ioping_output`
bytes_per_second=`awk -F' ' '{print $4}' ioping_output`
min_usec=`awk -F' ' '{print $5}' ioping_output`
avg_usec=`awk -F' ' '{print $6}' ioping_output`
max_usec=`awk -F' ' '{print $7}' ioping_output`
mdev_usec=`awk -F' ' '{print $8}' ioping_output`

cat >session.json <<EOF
{
  "sessionTemplate" : {
                        "href" : "session-template/api-key",
                        "key" : "$NUVLA_KEY",
                        "secret" : "$NUVLA_SECRET"
                      }
}
EOF

curl -H 'content-type: application/json' https://nuv.la/api/session -X POST \
    -d @session.json --cookie-jar ~/cookies -b ~/cookies -sS

cat >benchmark.json <<EOF
{
  "serviceOffer": {
      "href": "$SERVICE_OFFER",
      "connector": {"href": "$CLOUD"}
  },
  "credentials": [{"href": "credential/$NUVLA_KEY"}],
  "ioping:path": "$IOPING_PATH",
  "ioping:size": "$IOPING_SIZE",
  "ioping:requests": $IOPING_COUNT,
  "ioping:avg_usec": $avg_usec,
  "ioping:max_usec": $max_usec,
  "ioping:min_usec": $min_usec,
  "ioping:mdev_usec": $mdev_usec,
  "ioping:duration_usec": $duration_usec,
  "ioping:iops": $iops,
  "ioping:bytes_per_second": $bytes_per_second,
  "ioping:freetext": "ioping -c $IOPING_COUNT -w $IOPING_DEADLINE -s $IOPING_SIZE -B -D $IOPING_PATH",
  "acl" : {
      "owner" : {
        "principal" : "ADMIN",
        "type" : "ROLE"
      },
      "rules" : [ {
        "type" : "ROLE",
        "principal" : "USER",
        "right" : "VIEW"
      } ]
  }
}
EOF

curl -X POST --cookie-jar ~/cookies -b ~/cookies -sS \
    -H "Content-Type: application/json" \
    https://nuv.la/api/service-benchmark \
    -d @benchmark.json
