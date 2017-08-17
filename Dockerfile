FROM ubuntu:16.04
# Read the README.md for more details on the image configuration

MAINTAINER Jaroslav Brazda <jaroslav.brazda@gmail.com>

#you can override the target installation directory
ARG INSTALL_DIR=/informatica/agent
# Defines whre to download agent from (this might be different for your org)
ARG AGENT_URL=https://app2.informaticacloud.com/saas/download/linux64/installer/agent64_install.bin

# install system tools
RUN apt-get update && \
	apt-get -y install curl \
	less \
	locales \
	locales-all \
	sudo \
	unzip

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8    

# we need to run docker image under a different user than root because the Secure agent process engine can't be run under root account
RUN useradd --create-home -ms /bin/bash -U agent
USER agent

#download and prepare Installer
RUN curl -o /tmp/agent64_install.bin $AGENT_URL && \
	chmod +x /tmp/agent64_install.bin

#install	
RUN ( /tmp/agent64_install.bin -i silent || true )

#cleanup	
RUN rm -rf /tmp/agent64_install.bin

WORKDIR /home/agent/infaagent/apps/agentcore

CMD [ "./agent_start.sh" ]