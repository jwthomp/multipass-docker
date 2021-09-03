#!/usr/bin/env bash

kill_background() {
    # Disable the trap so we don't get into a loop
    trap - SIGTERM
    echo "Killing Background Proxies"
    # $$ is this process and will kill all children that are attached
    kill -- -$$
}

# Create the trap to call kill_background on a signal
trap "kill_background" SIGINT SIGTERM EXIT

# Loop through all passed in ports and bind them, any errors will result in a signal
# which will cause the trap to be fired
for port in "${@}"
do
    echo "Binding localhost:${port} to docker.local:${port}"
    socat "tcp-listen:${port},bind=localhost,reuseaddr,fork" "tcp:docker.local:${port}" &
    if [[ $? -ne 0 ]]; then 
        exit $?
    fi
done

# Stop this script from exiting which would kill all of the background socat processes
read -n 1 -s -r -p "Press any key to continue"

# Stick a newline down in case enter/return was not pressed.
echo
