# Run Informatica Agent in Docker Container

## Description
This package contains example docker file and supporting scripts to run Informatica CLoud Secure Agent on a Docker Container

## Use

1. Make sure you have docker installed gor to (https://docs.docker.com/engine/installation/)
2. Clone this repo  `git clone `
3. Update the `Dockerfile`  if necessary (Location of the SA agent installer maight be different ofr your Informatica CLoud org) You can override the default location by specifying `--build-arg <varname>=<value>` in nextr step
4. Run `docker build -t ic-secure-agent:1.0 .`
5. run `run -d -h <hostname> --name <agent_name> <image_name:image_tag>`
    +  `docker run -d -h agent1 --name agent1 ic-secure-agent:1.0`
6. We need to configure the agent to connect it to your Informatica Cloud Org When you running agent for the first time, run followinng command in the host machine to connect to running agent
    `docker exec -it ic-agent1 bash`
7. Then run following command to configure agent `./consoleAgentManager.sh configure '<sername>' '<password>'`
8. you can monitor agent running by calling `docker exec -it ic-agent1 less agentCore.log`




