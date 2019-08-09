#!/bin/sh

# If we do not need to register a service just run the command
if [[ ${SERVICE_JSON} == "" ]]; then
  exec "$@"
  exit $?
fi

until consul members; do
  echo "Waiting for Consul to start"
  sleep 1
done

# register the service with consul
consul services register ${SERVICE_JSON}

exec "$@"
