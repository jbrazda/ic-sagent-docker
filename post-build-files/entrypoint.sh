#!/bin/bash

AGENT_HOME=$1
USERNAME=$2
PASSWORD=$3

_term() { 
  printf "%s\n" "Caught SIGTERM signal, stopping agent!" 
  $AGENT_HOME/main/agentcore/consoleAgentManager.sh shutdown
}

trap _term SIGINT SIGTERM

if [ "$USERNAME" == "--help" ]
then
    echo 'docker run -d IMAGE[:TAG] <ics-username> <ics-password>'
else
	nohup /informatica/agent/register-agent.sh $AGENT_HOME $USERNAME $PASSWORD > /informatica/agent/register.nohup &
	$AGENT_HOME/agent_start.sh & wait $!
fi