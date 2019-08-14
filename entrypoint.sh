#!/bin/bash

# Wait until Consul can be contacted
until consul members; do
  echo "Waiting for Consul to start"
  sleep 1
done

# If we do not need to register a service just run the command
if [ ! -z "$SERVICE_JSON" ]; then
  # register the service with consul
  echo "Registering service with consul $SERVICE_JSON"
  consul services register ${SERVICE_JSON}
  
  # make sure the service deregisters when exit
  trap "consul services deregister ${SERVICE_JSON}" SIGINT SIGTERM EXIT
fi

# register any central config
if [ ! -z "$CENTRAL_CONFIG" ]; then
  IFS=';' read -r -a configs <<< ${CENTRAL_CONFIG}

  for i in "${configs[@]}"; do
    echo "Register central config $i"
	  curl -XPUT -d @$i ${CONSUL_HTTP_ADDR}/v1/config 
  done
fi

# Run the command 
exec "$@" &

# Block using tail so the trap will fire
tail -f /dev/null &
PID=$!
wait $PID
