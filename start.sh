#!/usr/bin/env bash

[[ -f $DEVPI_SERVERDIR/.serverversion ]] || initialize=yes

# Properly shutdown devpi server
shutdown() {
    devpi-server --stop  # Kill server
    kill -SIGTERM $TAIL_PID  # Kill log tailing
}

trap shutdown SIGTERM SIGINT

if [[ $initialize = yes ]]; then
  # Set root password
  echo "Initializing server"
  devpi-server --init --host 0.0.0.0 --port $DEVPI_PORT --theme $DEVPI_THEME --serverdir $DEVPI_SERVERDIR
  echo "Starting server"
  devpi-server --start --host 0.0.0.0 --theme $DEVPI_THEME --port $DEVPI_PORT --serverdir $DEVPI_SERVERDIR
  echo "Using server"
  devpi use http://0.0.0.0:$DEVPI_PORT
  echo "Logging in server as root"
  devpi login root --password=''
  echo "Updating root password"
  devpi user -m root password="${DEVPI_PASSWORD}"
  if [ ! -z "$CUSTOM_INDEX" ]; then
    echo "Creating custom index $CUSTOM_INDEX"
    devpi index -y -c "${CUSTOM_INDEX}" bases=root/pypi pypi_whitelist='*'
  fi
  echo "Shutting down server"
  devpi-server --stop
fi

# Need $DEVPI_SERVERDIR
echo "Starting server"
devpi-server --start --host 0.0.0.0 --theme $DEVPI_THEME --port $DEVPI_PORT --serverdir $DEVPI_SERVERDIR

DEVPI_LOGS=$DEVPI_SERVERDIR/.xproc/devpi-server/xprocess.log

echo "Using server"
devpi use -l http://0.0.0.0:$DEVPI_PORT

# Authenticate for later commands
echo "Logging in as root"
devpi login root --password="${DEVPI_PASSWORD}"

tail -f $DEVPI_LOGS &
TAIL_PID=$!

# Wait until tail is killed
wait $TAIL_PID

# Set proper exit code
wait $DEVPI_PID
EXIT_STATUS=$?
