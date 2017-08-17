# Run Informatica Agent in Docker Container

## Description
This package contains example docker file and supporting scripts to run Informatica CLoud Secure Agent on a Docker Container

## Use

1. Make sure you have docker installed, go to (https://docs.docker.com/engine/installation/)
2. Clone this repository
    ```shell
    git clone git@github.com:jbrazda/ic-sagent-docker.git
    ```
3. Update the `Dockerfile`  if necessary (Location of the SA agent installer might be different for your Informatica CLoud org) You can override the default location by specifying `--build-arg <name>=<value>` in next step
4. Run
    ```shell
    docker build -t ic-secure-agent:1.0 .
    ```

    To override the download file location use following

    ```shell
    docker build --build-arg AGENT_URL=https://app3.informaticacloud.com/saas/download/linux64/installer/agent64_install.bin -t ic-secure-agent:1.0 .
    ```
5. execute following command `run -d -h <hostname> --name <agent_name> <image_name:image_tag>`
    ```shell
    docker run -d -h agent1 --name ic-agent1 ic-secure-agent:1.0
    ```
6. We need to configure the agent to connect it to your Informatica Cloud Org When you running agent for the first time, run following command in the host machine to connect to running agent
    ```shell
    docker exec -it ic-agent1 bash
    ```
7. Then run following command to configure agent
    ```shell
    ./consoleAgentManager.sh configure '<username>' '<password>'
    ```
8. You can monitor agent running by calling
    ```shell
    docker exec -it ic-agent1 less agentCore.log
    ```




