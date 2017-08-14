# Run Informatica Agent in Docker Container

## Description
This package contains example docker file and supporting scripts to run Informatica CLoud Secure Agent on DOcker Container

## Use

1. Make sure you have docker installed
2. Clone this repo  `git clone`
3. Update the `Dockerfile`  if necessary (Location of the SA agent installer maight be different ofr your Informatica CLoud  org)
4. run `run -d -h <hostname> --name <agent_name> <image_name:image_tag> <agent_username> <agent_password>`
    example ""


This docker file is based on Jeremy Weber's original used internally at Informatica
first time you need to provide host name, name, and agent required creds
example run command: `docker run -d -h <hostname> --name <agent_name> <image_name:image_tag> <agent_username> <agent_password>`
-  `docker run -d -h agent1 --name agent1 test:3 jbrazda@informatica.org bp3luser`
-  `docker run -d -h agent2 --name agent2 test:3 jweber@informatica.com bp3luser`
subsequent runs can be done via docker start <container_id>
