FROM debian:8.1
#first time you need to provide host name, name, and agent required creds
##example run command: docker run -d -h <hostname> --name <agent_name> <image_name:image_tag> <agent_username> <agent_password>
##ie., docker run -d -h jw2 --name jw2 test:3 jweber@000qio.org jetssuck
##ie., docker run -d -h jw1 --name jw1 test:3 jweber@informatica.com bp3luser
#subsequent runs can be done via docker start <container_id>

MAINTAINER Jaroslav Brazda <jaroslav.brazda@gmail.com>

# Upgrading system for wget and unzip tools
RUN apt-get update && \
	apt-get -y install wget && \
	apt-get -y install unzip

COPY ./post-build-files /informatica/agent/

#setup
RUN mkdir "/informatica/agent/installer" && \ 
	wget --no-check-certificate "https://app2.informaticacloud.com/saas/download/linux64/installer/agent64_install.bin" -O /informatica/agent/installer/agent64_install.bin && \
	chmod +x /informatica/agent/entrypoint.sh && \
    chmod +x /informatica/agent/register-agent.sh && \
	chmod +x /informatica/agent/installer/agent64_install.bin

#install	
RUN chmod +x /informatica/agent/run_install.sh &&\
    /informatica/agent/run_install.sh &&\
    rm /informatica/agent/infaagent/main/tools/unzip/unzip &&\
    ln -s /usr/bin/unzip /informatica/agent/infaagent/main/tools/unzip/unzip

#post install	
RUN update-alternatives --install /usr/bin/java java /informatica/agent/infaagent/jre/bin/java 100 
	#unzip -o /informatica/work/agent_jars.zip -d /informatica/agent/infaagent

#cleanup	
RUN rm /informatica/agent/installer/agent64_install.bin

ENTRYPOINT ["/informatica/agent/entrypoint.sh", "/informatica/agent/infaagent"]
