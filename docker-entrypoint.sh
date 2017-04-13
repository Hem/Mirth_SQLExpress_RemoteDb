#! /bin/bash

set -e

if [ "$1" = 'java' ]; then
    chown -R mirth /opt/mirth-connect/appdata
    envsubst < /mirth.properties.template > /opt/mirth-connect/conf/mirth.properties
    exec gosu mirth "$@"
fi

exec "$@"