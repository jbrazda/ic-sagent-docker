#!/bin/bash

AGENT_HOME=$1
USERNAME=$2
PASSWORD=$3
COUNTER=1

echo 'Waiting for agent core to start'
sleep 10
CONFIGURED=`$AGENT_HOME/main/agentcore/consoleAgentManager.sh isConfigured`

while [[ -z $CONFIGURED &&  $COUNTER -lt 31 ]]
do
    sleep 1
    CONFIGURED=`$AGENT_HOME/main/agentcore/consoleAgentManager.sh isConfigured`
    COUNTER=$[$COUNTER +1]
done

if [ -z $CONFIGURED ]
then
   echo 'Agent core not started!'
elif [ "$CONFIGURED" != "true" ]
then
   $AGENT_HOME/main/agentcore/consoleAgentManager.sh configure $USERNAME $PASSWORD
fi