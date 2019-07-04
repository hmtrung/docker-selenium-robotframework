#!/bin/bash
# wait-for-grid.sh

set -e

cmd="$@"
unset http_proxy

while ! curl -sSL "http://192.168.89.193:4444/wd/hub/status" 2>&1 \
        | jq -r '.value.ready' 2>&1 | grep "true"; do
    echo 'Waiting for the Grid'
    sleep 1
done

>&2 echo "Selenium Grid is up - executing tests"
exec $cmd
