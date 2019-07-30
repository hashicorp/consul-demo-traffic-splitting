#!/bin/sh

until consul members; do
  echo "Waiting for Consul to start"
  sleep 1
done

# register the service with consul
consul services register ${SERVICE_JSON}

exec "$@"
