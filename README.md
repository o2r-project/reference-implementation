# o2r reference implementation

A catch-all repository to run all [o2r](https://o2r.info) microservices and the user interface platform which together form the [o2r prototype for a reproducibility service and publishing system](https://o2r.info/results).

In the remainder of this document, specifications or projects are referenced with their code repository, even if a user-friendly online HTML rending exists, e.g.  https://github.com/o2r-project/erc-spec/ instead of  https://o2r.info/erc-spec/.
Please check the code repository metadata or respective README files for documentation that is easier to read or browse.

## Run o2r platform and reproducibility service

### tl;dr

To quickly get the reference implementation running locally, you can use the ready-to-use images from Docker Hub with

```bash
git clone https://github.com/o2r-project/reference-implementation.git
cd reference-implemenation
make hub
```

or jump ahead the the section [Reproduce](#reproduce) to use the archived reproduction package.

### Basics

The o2r reference implementation realises a workflow for publishing reproducible articles using the [Executable Research Compendium](https://github.com/o2r-project/erc-spec) (ERC) and has two broad components: a user interface for demonstrating novel interactions with ERC, a.k.a. the "platform", and a side collection of microservices implementing the [o2r Web API](https://github.com/o2r-project/o2r-web-api), a.k.a. the "reproducibility service".

For more information on the architecture and the microservices see [o2r System Architecture](https://github.com/o2r-project/architecture).

### Contents

All of the software, specification and documentation for the o2r system are available nested in this project.
Deprectated projects are not included as submodules anymore but are listed below for transparency.

| **Component** | **Directory | **Online** |
| ------ | ------ | ------ |
| ERC specification (document) | `erc-spec` | https://github.com/o2r-project/erc-spec/ |
| Web API specification (document) | `api` | https://github.com/o2r-project/api |
| Architecture specification (document) | `architecture` | https://github.com/o2r-project/architecture |
| ERC checker (library/tool) | `erc-checker` | https://github.com/o2r-project/erc-checker/ |
| ERC and workspace examples (misc) | `erc-examples` | https://github.com/o2r-project/erc-examples |
| ~~bindings (microservice)~~ deprecated, now part of `o2r-UI` | `o2r-bindings` | https://github.com/o2r-project/o2r-bindings |
| bouncer (microservice) | `o2r-bouncer` | https://github.com/o2r-project/o2r-bouncer |
| ~~finder (microservice, using Elasticsearch)~~ deprecated, devlopment stopped | `o2r-finder` | https://github.com/o2r-project/o2r-finder |
| informer (microservice) | `o2r-informer` | https://github.com/o2r-project/o2r-informer |
| ~~loader (microservice)~~ deprecated, now part of `o2r-muncher` | `o2r-loader` | https://github.com/o2r-project/o2r-loader |
| meta (CLI tool) | `o2r-meta` | https://github.com/o2r-project/o2r-meta|
| muncher (microservice) | `o2r-muncher` | https://github.com/o2r-project/o2r-muncher |
| ~~platform (web UI)~~ deprecated, see `o2r-UI` | `o2r-platform` | https://github.com/o2r-project/o2r-platform|
| shipper (microservice) | `o2r-shipper` | https://github.com/o2r-project/o2r-shipper |
| ~~substituter (microservice)~~ deprecated, now part of `o2r-muncher` | `o2r-substituter` | https://github.com/o2r-project/o2r-substituter |
| guestlister (microservice) | `o2r-guestlister` | https://github.com/o2r-project/o2r-guestlister |
| ~~transporter (microservice)~~ deprecated, now part of `o2r-muncher` | `o2r-transporter` | https://github.com/o2r-project/o2r-transporter |
| UI | `o2r-UI` | https://github.com/o2r-project/o2r-UI |

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

This allows access to the o2r platform by selecting one of three demo users.
The users represent different user roles with different levels, i.e. an admin (level `1000`), an editor (level `500`) and a regular author (level `100`).

##### ORCID (optional)

The reference implementation can be alternatively configured to use [ORCID](https://orcid.org/) for authentication and authorisation, replacing the offline login provided by o2r-guestlister.

This requires an ORCID account which provides authentication tokens for public API client application with **[ORCID Sandbox](https://sandbox.orcid.org/signin)** (preferred for testing) or the registering an application as [described here](https://support.orcid.org/knowledgebase/articles/343182-register-a-public-api-client-application) with your regular ORCID account.

In the developer tools, use any name, website URL, and description.
Important is the `Redirect URIs` list, which must include `http://localhost` for your local installation.

The client ID, client secret, redirect URI and the OAuth URLs have to be provided by modifying the `.env` file in the base directory.
Note that environment variables provided through the shell have priority over the `.env` file configuration.
For more information on how the `.env` file works, see the [`docker-compose` documentation](https://docs.docker.com/compose/env-file/).

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

You have to **log in** to upload workspaces:

1. Click on "LOGIN" in the upper right hand corner
1. You are taken to a local login server: select one of the available users, e.g. "User"
1. After selecting the account type you are redirected to the o2r platform landing page

The o2r API supports two way to load scientific workflows: direct upload as a ZIP archive, or loading from a publish share.

- Ready to use **direct upload examples** are available in the directory `erc-examples`.
- Examples for **loading from a public share** are available [in this online share](https://uni-muenster.sciebo.de/index.php/s/G8vxQ1h50V4HpuA) (see file `README.txt`) and via the "EXAMPLES" menu in the "Create" section of the platform website.

After filling in required metadata you can publish the ERC.
Then open the ERC page and start a new job.
Check the job results and explore the interaction possibilities

### Explore back-end

#### Database administration

An [adminMongo](https://adminmongo.markmoffat.com/) instance is included in the reference implementation.
Open it at http://localhost:1234.
In mongoAdmin manually create a connection to host database:

- Connection name: any name, e.g. `o2r`
- Connection string: `mongodb://mongodb:27017` (which is the default port and the host `mongodb`, no password)
- Connection options: leave to `{}` (empty/default)

Wait a few moments for the interface to refresh, then click "Connect" in the line of the just created connection to explore the main database.

#### File storage

The configurations all use a common [Docker volume](https://docs.docker.com/engine/admin/volumes/volumes/) `o2rvol` with the global name `referenceimplementation_o2rvol`.

The volume can be inspected for development purposes:

```bash
docker volume ls
docker volume inspect reference-implementation_o2r_test_storage
```

## Read documentation

This repository also contains specification and documentation projects.
These documentations are created in different formats, using Markdown and OpenAPI.
Current PDF documents can be downloaded from the respective websites using the make target `get_documentation`.

## Reproducibility

### Rationale

This repository serves the goal to make the developments of the o2r project reproducible, not only by running the reference implementation (see above) but also by creating an archivable package of the software in a reproducible (i.e. scripted) way.
As the implementation components are spread over multiple git repositories and rely on container images for reproduction, we cannot use the direct export of a GitHub release to Zenodo.
This repository captures all software projects to create a reproduction package, which can be uploaded to a data repository manually.

### Known limitations

- Nested code projects are currently installed from GitHub during the building of Docker images ((see also [#1](#1)).
  - `o2r-muncher`'s Docker image contains `o2r-meta` and `erc-checker`
  - `o2r-loaders`'s Docker image contains `o2r-meta`
- The used Docker base images and dependencies for the services, such as npm or pip packages, must be available online in the required version to build the images locally.
  See project files such as `package.json` or `requirements.txt` for a full list of dependencies.
- The locally built images do not have a proper version tag but instead are `latest`, since they are build as part of the `docker-compose` configuration.
  Note that you can easily distinguish images by this, too: The hub images will always have a specific version tag.

### Create package

The creation of the reproducibility package consists of the following steps and relies on `Makefile` targets where possible (see brackets `(make ...)`).
The package uses the locally built images.

1. Clone the `reference-implementation` repository to an empty directory: `git clone https://github.com/o2r-project/reference-implementation.git`
1. Create the package with `make package`, which...
  - cleans up existing artifacts (`make package_clean local_clean`),
  - prints _used_ software versions (git, Docker etc., `make versions`),
  - updates the nested projects (`make update`),
  - builds all documentation locally (`make build_documentation`),
  - saves local version information of software and repositories to single file `versions.txt` (`make local_versions_save`),
  - builds all images locally (see [limitations](#known-limitations), `make local_build`),
  - saves the just built images into the file `o2r-reference-implementation-images.tar` (`make local_save_images`),
  - saves all nested repositories (including their histories)
    - reference implementation software to `o2r-reference-implementation-modules.zip`
    - documentation to `o2r-docs.zip`
    - reproduction package files (everything except `README` files and `Makefile`) to `o2r-reference-implementation-files.zip`
1. Create a new deposit or a new version of the existing deposit on Zenodo
1. Upload the _small files_ to the just created Zenodo deposit ([first version](https://zenodo.org/api/deposit/depositions/2203844), the used Python scripts needs the module `humanfriendly`; `ZENODO_DEPOSIT_ID=xxxxxx ZENODO_ACCESS_TOKEN=xxxxxx make upload_files_to_zenodo`)
1. Manually upload the _big file_ to Zenodo deposit ([Zenodo API currently has a 100 MB file limit](http://developers.zenodo.org/#deposition-files))
1. Fill out metadata form on Zenodo and publish using the "Publish" button

### Reproduce

The reproduction consists of the following steps:

1. Install [Docker CE](https://docs.docker.com/install/) and [`docker-compose`](https://docs.docker.com/compose/install/)
1. Download all files of the reproduction package from Zenodo: https://10.5281/zenodo.2203844
1. Unzip the file `o2r-docs.zip` and `o2r-reference-implementation-files.zip` - they contain documentation you might want to explore, and required configuration files and examples respectively.
1. Unzip the file `o2r-reference-implementation-modules.zip` - it contains the source code of all software and [the directories are needed for `docker-compose`](https://github.com/docker/compose/issues/3391) even though they are not used
1. Load the saved images from the tarball using `docker load`.
1. Run the reference implementation with `docker-compose up` using the configuration file `docker-compose-local.yml` and making sure the loaded images are used with the option `--no-build` (i.e. not building the images)

All except the first two steps can be executed with

```bash
make reproduce
```

Wait until the log shows no new messages for a few seconds, then open **http://localhost** and continue see section ["Load data"](#load-data) for creating ERCs.

You can stop all containers with `Ctrl+C` and clean up local images and files with

```bash
make local_down
# to also delete local storage use: make local_down_volumes
make local_clean
```

Please check the [Docker documentation](https://docs.docker.com/) if any problems arise and feel free to contact the [o2r team](https://o2r.info/about/#team).

## License

This project is licensed under Apache License, Version 2.0, see file LICENSE.
Copyright © 2018 - o2r project.

All included software projects and data files have their respective and potentially differing licenses, see e.g. `<component name>/LICENSE`.
