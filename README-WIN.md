# o2r reference implementation on Windows

This document contains Windows-specific configuration and steps.

**Please carefully read the sections "Basics" and "Prerequisites" in the file `README.md` for general information.
In the sections "Build images from source and run" and "Build images from source and run", please be aware of the general remarks but use the commands from this file instead.

## Windows with Docker for Windows

[Docker for Windows](https://docs.docker.com/docker-for-windows/) is available for 64bit Windows 10 Pro, Enterprise and Education (with Hyper-V available) and on Windows Server 2016 (see [Docker Docs](https://docs.docker.com/docker-for-windows/install/#what-to-know-before-you-install)).

The environmental variables must be passed separately on Windows, followed by the docker-compose commands:

```powershell
$env:OAUTH_CLIENT_ID = <...>
$env:OAUTH_CLIENT_SECRET = <...>
$env:OAUTH_URL_CALLBACK = <...>
$env:ZENODO_TOKEN = <...>
docker-compose up
```

The services are available at `http://localhost`.

##  Windows with Docker Toolbox

If your system does not meet the requirements to run Docker for Windows, you can install Docker Toolbox, which uses Oracle Virtual Box instead of Hyper-V, see [Docker Docs](https://docs.docker.com/toolbox/overview/).

When using Compose with Docker Toolbox/Machine on Windows, [volume paths are no longer converted from by default](https://github.com/docker/compose/releases/tag/1.9.0), but we need this conversion to be able to mount the docker volume to the o2r microservices. To re-enable this conversion for `docker-compose >= 1.9.0` set the environment variable `COMPOSE_CONVERT_WINDOWS_PATHS=1`.

Also, the client's defaults (i.e. using `localhost`) does not work. We must mount a config file to point the API to the correct location, see `win/config-toolbox.js`, and use the prepared configuration file `win/docker-compose-toolbox.yml`.

```bash
COMPOSE_CONVERT_WINDOWS_PATHS=1 OAUTH_CLIENT_ID=<...> OAUTH_CLIENT_SECRET=<...> OAUTH_URL_CALLBACK=<...> ZENODO_TOKEN=<...> docker-compose up
```

The services are available at `http://<machine-ip>`.