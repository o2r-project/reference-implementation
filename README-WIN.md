# o2r reference implementation on Windows

This document contains Windows-specific configuration and steps.

**Please carefully read the sections "Basics" and "Prerequisites" in the file `README.md` for general information.
In the sections "Build images from source and run" and "Build images from source and run", please be aware of the general remarks but use the commands from this file instead.
Take a look at the "Troubleshooting" sections in this file if you run into problems.

## Windows with Docker for Windows

[Docker for Windows](https://docs.docker.com/docker-for-windows/) is available for 64bit Windows 10 Pro, Enterprise and Education (with Hyper-V available) and on Windows Server 2016 (see [Docker Docs](https://docs.docker.com/docker-for-windows/install/#what-to-know-before-you-install)).

The environmental variables must be passed separately on Windows, followed by the docker-compose commands:

```shell
setx OAUTH_CLIENT_ID = "<... required ...>"
setx OAUTH_CLIENT_SECRET = "<... required ...>"
setx OAUTH_URL_CALLBACK = "http://localhost/api/v1/auth/login"
setx SHIPPER_REPO_TOKENS = "<... optional ...>"
docker-compose up
```

The services are available at `http://localhost`.


### Troubleshooting

- Note that SHIPPER_REPO_TOKENS is a json object of the following form: `{"zenodo": "$ZENODO_TOKEN", "zenodo_sandbox": "$ZENODO_SANDBOX_TOKEN", "download": "" }`. It might have to be escaped when entered via the commandline or PowerShell.
- Make sure that the drive where you cloned this repository to is shared (Docker > Shared Drives), because a configuration file (`nginx.conf`) must be mounted into the service `webserver`.
- Reconsider using a Linux virtual machine.
- Install the latest _edge_ channel of Docker, see https://docs.docker.com/docker-for-windows/faqs/#questions-about-stable-and-edge-channels
- Make sure that mounting files into containers works. This thread contains many potentially useful hints and ideas: https://forums.docker.com/t/volume-mounts-in-windows-does-not-work/10693/4
- If you want to set environment variables in PowerShell, use this syntax `$env:VARIABLENAME = "VARIABLEVALUE"`
- Inspect your environment variables in PowerShell with `Get-ChildItem Env:`
- If you encounter problems with docker-compose, you might want to install python 2.7, especially when a newer python distribution is installed on your machine

##  Windows with Docker Toolbox

If your system does not meet the requirements to run Docker for Windows, you can install Docker Toolbox, which uses Oracle Virtual Box instead of Hyper-V, see [Docker Docs](https://docs.docker.com/toolbox/overview/).

When using Compose with Docker Toolbox/Machine on Windows, [volume paths are no longer converted from by default](https://github.com/docker/compose/releases/tag/1.9.0), but we need this conversion to be able to mount the docker volume to the o2r microservices. To re-enable this conversion for `docker-compose >= 1.9.0` set the environment variable `COMPOSE_CONVERT_WINDOWS_PATHS=1`.

Also, the client's defaults (i.e. using `localhost`) does not work. We must mount a config file to point the API to the correct location, see `win/config-toolbox.js`, and use the prepared configuration file `win/docker-compose-toolbox.yml`.

```bash
COMPOSE_CONVERT_WINDOWS_PATHS=1 OAUTH_CLIENT_ID=<...> OAUTH_CLIENT_SECRET=<...> OAUTH_URL_CALLBACK=<...> SHIPPER_REPO_TOKENS=<...> docker-compose up
```

The services are available at `http://<machine-ip>`.
