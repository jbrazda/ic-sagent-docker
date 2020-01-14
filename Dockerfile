FROM ubuntu:18.04
# Read the README.md for more details on the image configuration.
# You can use different baseline image or linux distribution 
# but you will likely need to change supporting tools installation and  environment settings

MAINTAINER Jaroslav Brazda <jaroslav.brazda@gmail.com>

# Defines where to download agent from (this might be different for your org)
# This URL will have following pattern for latest IICS Orgs
# ARG AGENT_URL=https://<pod>.<region>.informaticacloud.com/saas/download/linux64/installer/agent64_install_ng_ext.bin
# Default is location for na1.dm-us.informaticacloud.com/
ARG AGENT_URL=https://na1.dm-us.informaticacloud.com/saas/download/linux64/installer/agent64_install_ng_ext.bin

# Updates Agent Core Ini File <Secure Agent installation directory>/apps/agentcore/conf/infaagent.ini
# Agent Core InfaAgent.GroupName=<Secure Agent group name>
ARG AGENT_GROUP_NAME=NA

# Required User Name to te register agent
ARG AGENT_USERNAME
ARG USER_TOKEN


# install system tools
RUN apt-get update && apt-get install -y \
curl \
less \
locales \
locales-all \
sudo \
unzip

# Set the locale, Locale defaults are necessary for agent to operate correctly
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# We need to run docker image under a different user than root 
# Secure agent process engine can't be run under root account
RUN useradd --create-home -ms /bin/bash -U agent
USER agent

# 1. Download and prepare Installer
# 2. Set file permissions
# 3. Install using silent install and the default location
# 4. Cleanup
# 5. Set Agent Group
RUN curl -o /tmp/agent64_install.bin $AGENT_URL && \
    chmod +x /tmp/agent64_install.bin && \ 
    /tmp/agent64_install.bin -i silent && \
    rm -rf /tmp/agent64_install.bin && \
    echo "\nInfaAgent.GroupName=$AGENT_GROUP_NAME" >> /home/agent/infaagent/apps/agentcore/conf/infaagent.ini && \
    cat /home/agent/infaagent/apps/agentcore/conf/infaagent.ini && \
    mkdir -p /home/agent/infaagent/apps/process-engine/logs && \
    mkdir -p /home/agent/infaagent/apps/process-engine/data

WORKDIR /home/agent/infaagent/apps/agentcore

# Register Agent
# RUN ./infaagent startup && \
#     sleep 20 && \
#     ./consoleAgentManager.sh isConfigured && \
#     ./consoleAgentManager.sh configureToken "$AGENT_USERNAME" "$USER_TOKEN" && \
#     ./consoleAgentManager.sh isConfigured && \
#     ./infaagent shutdown

## Define Volumes for Shared Data Staging area 
VOLUME [ "/data", "/home/agent/infaagent/apps/process-engine/logs", "/home/agent/infaagent/apps/process-engine/data"]

## Ports used by the agent that might be used for external Connections
# 7080 Process Engine Shutdown Port
# 7443 Process Engine https port
# 5432 Process Engine Postgres DB
EXPOSE 7080 7443 5432 

COPY run_agent.sh .

CMD [ "./run_agent.sh" ]