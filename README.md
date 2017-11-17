# o2r reference implementation

A catch-all repository to run all [o2r](http://o2r.info) microservices and the user interface platform.

## Run o2r platform and reproducibility service

### Basics

The o2r reference implementation realises a workflow for publishing reproducible articles using the [Executable Research Compendium](https://github.com/o2r-project/erc-spec) (ERC) and has two broad components: a user interface for demonstrating novel interactions with ERC, a.k.a. the "platform", and a side collection of microservices implementing the [o2r Web API](https://github.com/o2r-project/o2r-web-api), a.k.a. the "reproducibility service".

For more information on the architecture and the microservices see [o2r Software Architecture](https://github.com/o2r-project/architecture).

### Contents

All of the mentioned documentation and software is available in this project.
The documentation is also available online for reading, though availability may change.

| Component | directory | online |
| ------ | ------ | ------ |
| ERC specification (document) | `erc-spec` | http://o2r.info/erc-spec/ |
| Web API specification (document) | `o2r-web-api` | https://github.com/o2r-project/o2r-web-api |
| Architecture specification (document) | `architecture` | https://github.com/o2r-project/architecture |
| ERC checker (library/tool) | `erc-checker` | https://github.com/o2r-project/erc-checker/ |
| ERC and workspace examples (misc) | `erc-examples` | https://github.com/o2r-project/erc-examples |
| bouncer (microservice) | `o2r-bouncer` | https://github.com/o2r-project/o2r-bouncer |
| finder (microservice) | `o2r-finder` | https://github.com/o2r-project/o2r-finder |
| informer (microservice) | `o2r-informer` | https://github.com/o2r-project/o2r-informer |
| loader (microservice) | `o2r-loader` | https://github.com/o2r-project/o2r-loader |
| meta (CLI tool) | `o2r-meta` | https://github.com/o2r-project/o2r-meta|
| muncher (microservice) | `o2r-muncher` | https://github.com/o2r-project/o2r-muncher |
| platform (web UI) | `o2r-platform` | https://github.com/o2r-project/o2r-platform|
| shipper (microservice) | `o2r-shipper` | https://github.com/o2r-project/o2r-shipper |
| substituter (microservice) | `o2r-substituter` | https://github.com/o2r-project/o2r-substituter |
| transporter (microservice) | `o2r-transporter` | https://github.com/o2r-project/o2r-transporter |

### Supported operating systems

This project contains configurations and scripts to make running the o2r reference implementation as easy as possible.

The project uses [`make`](https://www.gnu.org/software/make/), which helps simplifying the execution of the various steps necessary to run your own o2r-platform into a simple set of commands. 
These commands are formulated in the `Makefile` included in this project.

The commands in _this file_ (`README.md`) assume a Unix shell and related common tools, so they work on a recent installation of Linux or MacOS X.

See the file `README-WIN.md` for Windows-specific instructions on running the reference implementation using Windows and/or Docker Toolbox.

**All information relevant to _both_ operating systems are only in this file.**

If you are familiar with virtual machines (VMs) we strongly consider you run the reference implementation in a Linux VM with the latest available Docker.

### Prerequisites

#### Software

The o2r reference implementation is build on [Docker](http://docker.com/).
You must [install Docker](https://www.docker.com/get-docker) (i.e. Docker Community Edition, _edge_ channel, tested with version `17.09.0-ce` but later version should work) and [docker-compose](https://docs.docker.com/compose/) (version `1.13.0` or higher) first to continue.

The tasks below are automated using [Make](https://en.wikipedia.org/wiki/Make_(software)).
Make sure that you have GNU Make (tested) or one of the derivatives (not tested) running on your system.
If Make is not available you can manually execute the required commands from the respective rule in the file `Makefile`.

#### Get files

You can download this repository using git with `git clone https://github.com/o2r-project/reference-implementation.git` or download an archive [here](https://github.com/o2r-project/reference-implementation/archive/master.zip).

All relevant software projects are included in this repository via [git submodules](https://git-scm.com/docs/git-submodule).
Run `make update` or the respective commands on your operating system to initialize and clone submodules before proceeding.

#### Accounts and tokens

##### ORCID

The reference implementation relies on [ORCID](https://orcid.org/) for authentication and authorisation.
There is no other way to log in on the platform, therefore you must enable your installation of the reference implementation to connect with the ORCID API.
The client credentials used by the o2r team cannot be shared publicly for security reasons.

You _must_ register a public API client application with ORCID as [described here](https://support.orcid.org/knowledgebase/articles/343182-register-a-public-api-client-application).

In the developer tools, use any name, website URL, and description.
Important is the `Redirect URIs` list, which must include `http://localhost` for your local installation.

The client ID, client secret, and redirect URI must then be provided to the docker-compose configurations via environment variables as shown below.

##### Repositories (optional)

The reference implementation can deliver the created ERC to different repositories.
These repositories also require an authentication token.

- [Create access token](https://zenodo.org/login/?next=%2Faccount%2Fsettings%2Fapplications%2Ftokens%2Fnew%2F) for [Zenodo](https://zenodo.org/)

- Note that SHIPPER_REPO_TOKENS is a json object of the following form: `{"zenodo": "$ZENODO_TOKEN", "zenodo_sandbox": "$ZENODO_SANDBOX_TOKEN", "download": "" }`. It might have to be escaped when entered.

#### Elasticsearch host preparation

The implementation uses an [Elasticsearch](http://elastic.co) document search engine.
Elasticsearch requires the ability to create many memory-mapped areas ([mmaps](https://en.wikipedia.org/wiki/Mmap)s) for fast access.
The usual "max map count" setting is [configured to low on many computers](https://www.elastic.co/guide/en/elasticsearch/reference/5.0/_maximum_map_count_check.html).

You may have to configure `vm.max_map_count` on the host to be at least `262144`, e.g. on Linux via `sysctl`.
You can find instructions for all hosts (including Docker Toolbox) in the [Elasticsearch docs](https://www.elastic.co/guide/en/elasticsearch/reference/5.0/docker.html#docker-cli-run-prod-mode).

### Build images from source and run

This repository already includes a `.gitmodules` file, which lists all required o2r microservices as git submodules. 
To download all o2r source code at once, navigate to the `reference-implementation` base directory and use

```bash
    make update
```

Once all repositories have been pulled successfully, build docker images of the microservices and run them in containers by executing:

```bash
O2R_ORCID_ID=<your orcid id> O2R_ORCID_SECRET=<your orcid secret> O2R_ORCID_CALLBACK=http://localhost/api/v1/auth/login SHIPPER_REPO_TOKENS={"your_repo": "your_token", ...} \
    make build_images run_local
```

Wait for a while, then open **http://localhost**.

### Download images and run

[Docker Hub](https://hub.docker.com/) is a repository for Docker images.
All o2r software projects have automatic builds [available on Docker Hub](https://hub.docker.com/r/o2rproject/).
The following command executes a `docker-compose` command to pull and run these images.

```bash
O2R_ORCID_ID=<your orcid id> O2R_ORCID_SECRET=<your orcid secret> O2R_ORCID_CALLBACK=http://localhost/api/v1/auth/login SHIPPER_REPO_TOKENS={"your_repo": "your_token", ...} \
    make run_hub
```

Wait a bit, then open **http://localhost**.

### Load data

The o2r API supports two way to load scientific workflows: direct upload as a ZIP archive, or import from a publish share.

Ready to use **Direct upload** examples are available in the directory `erc-examples`.

Examples for loading from a public share are available here: https://uni-muenster.sciebo.de/index.php/s/G8vxQ1h50V4HpuA (see file `README.txt`).

### Explore back-end

#### Database administration

An [adminMongo](https://adminmongo.markmoffat.com/) instance is included in the reference implementation. Open it at http://localhost:1234. In mongoAdmin please manually create a connection to host db, i.e. mongodb://db:27017 to edit the database (click "Update" first if you edit the existing connection, then "Connect").

The docker compose configuration includes an adminMongo instance. Open it at http://localhost:1234, create a new connection with the following settings:

- Connection name: any name
- Connection string: `mongodb://mongodb:27017` (which is the default port and the host `mongodb`, no password)
- Connection options: `{}` (empty/default)

Click on "Add connection", then on "Connections" at the top right corner, and then "Connect" using the just created connection.

#### File storage

The configurations all use a common [Docker volume](https://docs.docker.com/engine/admin/volumes/volumes/) `o2rvol` with the global name `referenceimplementation_o2rvol`.

The volume and network can be inspected for development purposes:

```bash
docker volume ls
docker volume inspect reference-implementation_o2r_test_storage
```

## Reproducibility

This repository serves the goal to make the developments of the o2r project reproducible, not only by running the reference implementation (see above) but also by creating an archivable package of the software.
As the implementations component are spread over multiple git repositories, we cannot rely on the direct export of a GitHub release to Zenodo.
This repository imports all relevant software projects as [git submodules](https://git-scm.com/docs/git-submodule) and manually creates a release package.

**TBD**

- clone repo
- build all images
- export all image
- create make target to load all images and run these
- create huge zip
- publish to Zenodo (with make target)

### Known limitations

- Nested code projects are currently installed from GitHub during the building of Docker images ((see also [#1]()).
  - `o2r-muncher`'s Docker image contains `o2r-meta` and `erc-checker`
  - `o2r-loaders`'s Docker image contains `o2r-meta`
- The used Docker base images and dependencies for the services, such as npm or pip packages, must be available online in the required version to build the images locally. See project files such as `package.json` or `requirements.txt` for a full list of dependencies.

### Create package

**TODO**


```bash
make show_microservices_versions >> dist/versions.txt
```

### Archival to Zenodo

**TODO**


## License

This project is licensed under Apache License, Version 2.0, see file LICENSE. Copyright © 2017 - o2r project.

All included software projects have their own LICENSE files, see `o2r-<component name>/LICENSE`.
