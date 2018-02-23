# o2r reference implementation on Windows

This document contains Windows-specific configuration and steps.

**Please carefully read the sections "Basics" and "Prerequisites" in the file `README.md` for general information.
In the sections "Build images from source and run" and "Build images from source and run", please be aware of the general remarks but use the `docker-compose` command from this file instead of the commands using `make`.
Take a look at the "Troubleshooting" sections in this file if you run into problems.**

## Windows with Docker for Windows

[Docker for Windows](https://docs.docker.com/docker-for-windows/) is available for 64bit Windows 10 Pro, Enterprise and Education (with Hyper-V available) and on Windows Server 2016 (see [Docker Docs](https://docs.docker.com/docker-for-windows/install/#what-to-know-before-you-install)).

Simply run the following command to start the services:

```shell
docker-compose up
```

The services are available at `http://localhost`.

Advanced configuration can be applied by editing the `.env` file or by specifying the settings as environment variables before executing the `docker-compose up` command.

### Troubleshooting

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

Add `COMPOSE_CONVERT_WINDOWS_PATHS=1` to the `.env` file and run:

```bash
docker-compose up
```

The services are available at `http://<machine-ip>`.
