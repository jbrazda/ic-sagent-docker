#!/usr/bin/env bash

## this wrapper takes care of running the agent and shutdown gracefully Under Docker
#set -x

# colors
red='\e[0;31m'
green='\e[0;32m'
yellow='\e[0;33m'
reset='\e[0m'

WORK_DIR=.
PID_FILE=$WORK_DIR/infaagentprocessid

#Colorized echo
echoRed() { echo -e "${red}$1${reset}"; }
echoGreen() { echo -e "${green}$1${reset}"; }
echoYellow() { echo -e "${yellow}$1${reset}"; }

# SIGUSR1-handler
my_handler() {
  echo "Stopped Wait Loop"
}

prep_term()
{
    unset term_child_pid
    trap 'handle_term' TERM INT
    # kill the last background process and execute the specified handler
    trap 'kill ${!}; my_handler' SIGUSR1
    echo 'Termination Handler Ready'
}

handle_term() {
    echo "TERM Signal Received. Shutting Down PID $term_child_pid..." 
    if [ -z "$(pgrep -F $PID_FILE)" ]; then
        echoRed "Process $term_child_pid not running";
        exit 143;
    else
        echoGreen "PID $term_child_pid found, shuting down..."
        ./infaagent shutdown 
        echo "Secure Agent Stopped"
        exit 143; # 128 + 15 -- SIGTERM
    fi
}

# set shutdown hooks
prep_term
# run application
./infaagent startup
# get agent process id
term_child_pid=$(cat $PID_FILE)
echoGreen "Secure Agent Starting pid:$term_child_pid"

# wait until terminated
while true
do
  tail -f /dev/null & wait ${!}
done
