#!/bin/sh

until consul members; do
  echo "Waiting for Consul to start"
  sleep 1
done

exec "$@"
