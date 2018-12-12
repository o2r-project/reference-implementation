# o2r reference implementation

A catch-all repository to run all [o2r](https://o2r.info) microservices and the user interface platform which together form the [o2r prototype for a reproducibility service and publishing system](https://o2r.info/results).

In the remainder of this document, specifications or projects are referenced with their code repository, even if a user-friendly online HTML rending exists, e.g.  https://github.com/o2r-project/erc-spec/ instead of  https://o2r.info/erc-spec/.
Please check the code repository metadata or respective README files for documentation that is easier to read or browse.

## Run o2r platform and reproducibility service

### tl;dr

To quickly get the reference implementation running locally, you can use the ready-to-use images from Docker Hub:

```bash
make hub
```

### Basics

The o2r reference implementation realises a workflow for publishing reproducible articles using the [Executable Research Compendium](https://github.com/o2r-project/erc-spec) (ERC) and has two broad components: a user interface for demonstrating novel interactions with ERC, a.k.a. the "platform", and a side collection of microservices implementing the [o2r Web API](https://github.com/o2r-project/o2r-web-api), a.k.a. the "reproducibility service".

For more information on the architecture and the microservices see [o2r System Architecture](https://github.com/o2r-project/architecture).

### Contents

All of the software, specification and documentation for the o2r system are available nested in this project.

| **Component** | **Directory | **Online** |
| ------ | ------ | ------ |
| ERC specification (document) | `erc-spec` | https://github.com/o2r-project/erc-spec/ |
| Web API specification (document) | `api` | https://github.com/o2r-project/api |
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
| guestlister (microservice) | `o2r-guestlister` | https://github.com/o2r-project/o2r-guestlister |
| transporter (microservice) | `o2r-transporter` | https://github.com/o2r-project/o2r-transporter |

### Supported operating systems

This project contains configurations and scripts to make running the o2r reference implementation as easy as possible.

The project uses [`make`](https://www.gnu.org/software/make/), which helps simplifying the execution of the various steps necessary to run the reference implementation into a set of console commands. 
These commands are formulated in the `Makefile` included in this project.
If `make` is not available, you can execute the respective commands manually.

The commands in _this file_ (`README.md`) assume a Unix shell and related common tools, so they work on a recent installation of Linux or MacOS X.

See the file `README-WIN.md` for Windows-specific instructions on running the reference implementation using Windows and/or Docker Toolbox.

**All information relevant to _both_ operating systems are only in this file.**

If you are familiar with virtual machines (VMs) we strongly consider you run the reference implementation in a Linux VM with the latest available Docker.

### Prerequisites

#### Software

The o2r reference implementation is build on [Docker](http://docker.com/).
You must [install Docker](https://www.docker.com/get-docker) (i.e. Docker Community Edition, tested with version `17.09.0-ce` but later versions should work) and [docker-compose](https://docs.docker.com/compose/) (version `1.13.0` or higher) first to continue.

The tasks below are automated using [Make](https://en.wikipedia.org/wiki/Make_(software)).
Make sure that you have GNU Make (tested) or one of the derivatives (not tested) running on your system.
If Make is not available you can manually execute the required commands from the respective rule in the file `Makefile`.

#### Get files

You can download this repository using git with `git clone https://github.com/o2r-project/reference-implementation.git` or download an archive [here](https://github.com/o2r-project/reference-implementation/archive/master.zip).

All relevant software projects are included in this repository via [git submodules](https://git-scm.com/docs/git-submodule).
Run `make update` or the respective commands on your operating system to initialize and clone submodules before proceeding.

#### Accounts and tokens

##### o2r-guestlister

By default, the reference implementation uses the offline OAuth2 implementation provided by the [o2r-guestlister](https://github.com/o2r-project/o2r-guestlister).

This allows access to the o2r platform by selecting one of three demo users. The users represent different user roles with different levels, i.e. an admin (level `1000`), an editor (level `500`) and a basic author (level `100`).

##### ORCID (optional)

The reference implementation can be alternatively configured to use [ORCID](https://orcid.org/) for authentication and authorisation, replacing the offline login provided by o2r-guestlister.

This requires an ORCID account which provides authentication tokens for public API client application with **[ORCID Sandbox](https://sandbox.orcid.org/signin)** (preferred for testing) or the registering an application as [described here](https://support.orcid.org/knowledgebase/articles/343182-register-a-public-api-client-application) with your regular ORCID account.

In the developer tools, use any name, website URL, and description.
Important is the `Redirect URIs` list, which must include `http://localhost` for your local installation.

The client ID, client secret, redirect URI and the OAuth URLs have to be provided by modifying the `.env` file in the base directory. Note that environment variables provided throught the shell have priority over the `.env` file configuration. For more information on how the `.env` file works, see the docker-compose [documentation](https://docs.docker.com/compose/env-file/).

##### Repositories (optional)

The reference implementation can deliver the created ERC to different repositories.
By default only the "Download" repository is supported, i.e. users may download a complete ERC as an archive file.
These repositories also require an authentication token.

- [Create access token](https://zenodo.org/login/?next=%2Faccount%2Fsettings%2Fapplications%2Ftokens%2Fnew%2F) for [Zenodo](https://zenodo.org/)

These tokens can be provided to the docker-compose configurations by setting them as environment variables in the `.env` file, similar to the ORCID configuration.

Modify the `SHIPPER_REPO_TOKENS` entry in the `.env` file to include the tokens:

```
SHIPPER_REPO_TOKENS={"zenodo": "<your Zenodo token>", "zenodo_sandbox": "<your Zenodo Sandbox token>", "download": "" }
```

#### Elasticsearch host preparation

The implementation uses an [Elasticsearch](http://elastic.co) document search engine.
Elasticsearch requires the ability to create many memory-mapped areas ([mmaps](https://en.wikipedia.org/wiki/Mmap)s) for fast access.
The usual "max map count" setting is [configured to low on many computers](https://www.elastic.co/guide/en/elasticsearch/reference/5.0/_maximum_map_count_check.html).

You may have to configure `vm.max_map_count` on the host to be at least `262144`, e.g. on Linux via `sysctl`.
You can find instructions for all hosts (including Docker Toolbox) in the [Elasticsearch docs](https://www.elastic.co/guide/en/elasticsearch/reference/5.0/docker.html#docker-cli-run-prod-mode).

### Build images from source and run

This repository already includes a `.gitmodules` file, which lists all required o2r microservices and tools as git submodules. 
To download all o2r source code at once, navigate to the `reference-implementation` base directory and use

```bash
make update
```

Once all repositories have been pulled successfully, build Docker images of the microservices and tools:

```bash
make local_build
```

Then run the microservices and platform in containers:

```bash
make local_up
```

Wait until the log shows no new messages for a few seconds, then open **http://localhost** and continue in section ["Load data"](#load-data).

The above three steps can also be executed with a single target:

```bash
make local
```

### Download images and run

[Docker Hub](https://hub.docker.com/) is a [public registry](https://en.wikipedia.org/wiki/Docker_(software)#Components) for Docker images.
All o2r software projects are automatically built [on Docker Hub](https://hub.docker.com/r/o2rproject/) when there is a new version uploaded to the code repository.
The images have tags corresponding to the software version (as specific e.g. in a `package.json` for a Node.js-based microservice).

The following target pulls the latest images, prints the versions to the terminal, and executes a `docker-compose` command to run the reference implementation:

```bash
make hub
```

Wait until the log shows no new messages for a few seconds, then open **http://localhost** and continue in section ["Load data"](#load-data).

### Load data

The o2r API supports two way to load scientific workflows: direct upload as a ZIP archive, or import from a publish share.

Ready to use **Direct upload** examples are available in the directory `erc-examples`.

Examples for loading from a public share are available [in this online share](https://uni-muenster.sciebo.de/index.php/s/G8vxQ1h50V4HpuA) (see file `README.txt`) and via the "EXAMPLES" menu in the "Create" section of the platform website.

### Use platform

1. Click on "LOGIN" in the upper right hand corner
1. Select one of the available users, e.g. "Author"
1. In the "Create" section of the platform website, select a workspace from the "EXAMPLES" menu
1. Fill in required metadata
1. Finish the upload and open the ERC page: explore the running job and all interaction possiblities

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

## Read documentation

This repository also contains specification and documentation projects.
These documentations are created in Markdown format and can be rendered to HTML and PDF documents using the make target `build_documentation`, which relies on a local `Dockerfile` for the rendering environment.
The PDF files are available to the project root directory.
The HTML files can be found in the respective projects in the `site` directory.

If the `local` configuration is used and the documentation was build, or if you [reproduce](#reproduce) you can also browse it at http://localhost/docs/.

## Reproducibility

### Rationale

This repository serves the goal to make the developments of the o2r project reproducible, not only by running the reference implementation (see above) but also by creating an archivable package of the software in a reproducible (i.e. scripted) way.
As the implementations component are spread over multiple git repositories, we cannot rely on the direct export of a GitHub release to Zenodo.
This repository captures all software projects to create a release package, which can be uploaded to a data repository manually.

### Known limitations

- Nested code projects are currently installed from GitHub during the building of Docker images ((see also [#1](#1)).
  - `o2r-muncher`'s Docker image contains `o2r-meta` and `erc-checker`
  - `o2r-loaders`'s Docker image contains `o2r-meta`
- The used Docker base images and dependencies for the services, such as npm or pip packages, must be available online in the required version to build the images locally. See project files such as `package.json` or `requirements.txt` for a full list of dependencies.
- The locally built images do not have a proper version tag but instead are `latest`, since they are build as part of the `docker-compose` configuration. Note that you can easily distinguish images by this, too: The hub images will always have a specific version tag.

### Create package

The creation of the reproducibility package consists of the following steps and is relies where possible on Makefile targets.
The package uses the remote images from Docker Hub at the time of creation

1. Clone the `reference-implementation` repository to an empty directory: `git clone https://github.com/o2r-project/reference-implementation.git`
1. Create the package with `make release`, which...
  - cleans up potentially existing artifacts (`make local_clean`),
  - prints software versions (`make versions`),
  - updates the nested projects (`make update`),
  - builds all documentation locally (`make build_documentation`),
  - save local version information of software and repositories to single file `versions.txt` (`make local_versions_save`),
  - builds all images locally (see [limitations](#known-limitations), `make local_build`),
  - saves the just built images into the file `o2r-reference-implementation-images.tar` (`make local_save_images`),
  - saves all nested code repositories with their histories, to `o2r-reference-implementation-modules.zip`
  - saves all nested documentation repositories with their histories, to `o2r-docs.zip`
1. Create a new deposit or a new version of the existing deposit on Zenodo
1. Upload the files to Zenodo deposit: `ZENODO_DEPOSIT_ID=2203844 ZENODO_ACCESS_TOKEN=xxxxxx make upload_deposit`
1. Fill out metadata form on Zenodo and publish using the "Publish" button

### Reproduce

The reproduction consists of three steps, assuming the local images do not exist on the machine used:

1. Download the saved images from Zenodo
1. Load the saved images from the tarball
1. Run the `docker-compose` configuration without building the images (to ensure the loaded ones are used)

The last two steps can be executed with

```bash
make reproduce
```

Wait until the log shows no new messages for a few seconds, then open **http://localhost** and continue see section ["Load data"](#load-data) for creating ERCs.

You can stop all containers and clean up local images with

```bash
make local_down
# to also delete local storage use make local_down_volumes
make local_clean
```

## License

This project is licensed under Apache License, Version 2.0, see file LICENSE. Copyright © 2018 - o2r project.

All included software projects have their own LICENSE files, see `<component name>/LICENSE`.
