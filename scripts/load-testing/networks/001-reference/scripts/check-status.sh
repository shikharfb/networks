#!/bin/bash

EXIT_CODE=0
SLEEP=${SLEEP:-3}

NODE_DOMAIN=${NODE_DOMAIN:-".sredev.co"}

if (( ${SLEEP} > 0 )); then
    echo "Waiting a few seconds for Tendermint network to start up..."
    sleep ${SLEEP}
fi

echo "Checking network status (assumes node configuration files are all in /tmp/nodes/)..."

# Run through each node and check its status to see if it's up
for CFG_FILE in $(find /tmp/nodes -name 'config.toml'); do
    NODE_ID=$(basename $(dirname $(dirname ${CFG_FILE})))
    if curl -s -m 3 "http://${NODE_ID}${NODE_DOMAIN}:26657/status" > /dev/null; then
        echo "${NODE_ID} is UP"
    else
        echo "${NODE_ID} is DOWN"
        EXIT_CODE=1
    fi
done

exit ${EXIT_CODE}
