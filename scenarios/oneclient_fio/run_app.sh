#!/bin/bash

. /root/env

# run ioping with direct IO (no caching)
ioping -c $IOPING_COUNT -w $IOPING_DEADLINE -s $IOPING_SIZE -D $IOPING_PATH > ioping_output

min=`grep "min/avg/max/mdev" ioping_output | awk -F'[/= ]' '{print $7}'`
min_units=`grep "min/avg/max/mdev" ioping_output | awk -F'[/= ]' '{print $8}'`
avg=`grep "min/avg/max/mdev" ioping_output | awk -F'[/= ]' '{print $11}'`
avg_units=`grep "min/avg/max/mdev" ioping_output | awk -F'[/= ]' '{print $12}'`
max=`grep "min/avg/max/mdev" ioping_output | awk -F'[/= ]' '{print $15}'`
max_units=`grep "min/avg/max/mdev" ioping_output | awk -F'[/= ]' '{print $16}'`
mdev=`grep "min/avg/max/mdev" ioping_output | awk -F'[/= ]' '{print $19}'`
mdev_units=`grep "min/avg/max/mdev" ioping_output | awk -F'[/= ]' '{print $20}'`

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
  "credentials": [{"href": "$NUVLA_KEY"}],
  "ioping:path": "$IOPING_PATH",
  "ioping:size": "$IOPING_SIZE",
  "ioping:requests": $IOPING_COUNT,
  "ioping:avg": $avg,
  "ioping:avg_units": "$avg_units",
  "ioping:max": $max,
  "ioping:max_units": "$max_units",
  "ioping:min": $min,
  "ioping:min_units": "$min_units",
  "ioping:mdev": $mdev,
  "ioping:mdev_units": "$mdev_units",
  "ioping:freetext": "ioping -c $IOPING_COUNT -w $IOPING_DEADLINE -s $IOPING_SIZE -D $IOPING_PATH",
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
