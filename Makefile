init:
	git clone https://github.com/o2r-project/reference-implementation
	cd reference-implementation
	git submodule add https://github.com/o2r-project/api
	git submodule add https://github.com/o2r-project/architecture
	git submodule add https://github.com/o2r-project/containerit
	git submodule add https://github.com/o2r-project/erc-spec
	git submodule add https://github.com/o2r-project/erc-checker
	git submodule add https://github.com/o2r-project/erc-examples
	git submodule add https://github.com/o2r-project/o2r-bouncer
	git submodule add https://github.com/o2r-project/o2r-finder
	git submodule add https://github.com/o2r-project/o2r-informer
	git submodule add https://github.com/o2r-project/o2r-inspecter
	git submodule add https://github.com/o2r-project/o2r-loader
	git submodule add https://github.com/o2r-project/o2r-meta
	git submodule add https://github.com/o2r-project/o2r-muncher
	git submodule add https://github.com/o2r-project/o2r-platform
	git submodule add https://github.com/o2r-project/o2r-shipper
	git submodule add https://github.com/o2r-project/o2r-substituter
	git submodule add https://github.com/o2r-project/o2r-transporter
	git submodule add https://github.com/o2r-project/o2r-guestlister
	git submodule add https://github.com/o2r-project/o2r-bindings
	git submodule add https://github.com/o2r-project/containerit

update:
	git pull
	git submodule update --init --recursive --remote
	git submodule foreach --recursive git checkout master
	git submodule foreach --recursive git pull origin master

local_build:
	docker-compose --file docker-compose-local.yml build;

local_up:
	docker-compose --file docker-compose-local.yml up;

local_down:
	docker-compose --file docker-compose-local.yml down;

local_down_volume:
	docker-compose --file docker-compose-local.yml down --volume;

local: update local_build local_up

local_versions:
	etc/local_versions.sh

local_versions_save: local_versions
	rm -f versions.txt
	make local_versions >> versions.txt

hub_images:
	# pull ":latest" images so that we don't need to update versions here as well
	docker pull o2rproject/o2r-bouncer;
	docker pull o2rproject/o2r-finder;
	docker pull o2rproject/o2r-informer;
	docker pull o2rproject/o2r-inspecter;
	docker pull o2rproject/o2r-loader;
	docker pull o2rproject/o2r-meta;
	docker pull o2rproject/o2r-muncher;
	docker pull o2rproject/o2r-platform;
	docker pull o2rproject/o2r-shipper;
	docker pull o2rproject/o2r-substituter;
	docker pull o2rproject/o2r-transporter;
	docker pull o2rproject/o2r-guestlister;
	docker pull o2rproject/o2r-bindings;

hub_versions:
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'	   o2rproject/o2r-bouncer;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'	    o2rproject/o2r-finder;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'      o2rproject/o2r-informer;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'     o2rproject/o2r-inspecter;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'        o2rproject/o2r-loader;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'          o2rproject/o2r-meta;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'       o2rproject/o2r-muncher;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'      o2rproject/o2r-platform;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.vcs-ref"}}'       o2rproject/o2r-shipper;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'   o2rproject/o2r-substituter;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'   o2rproject/o2r-transporter;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'   o2rproject/o2r-guestlister;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'      o2rproject/o2r-bindings;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'       o2rproject/containerit;

hub_up:
	docker-compose up;

hub: hub_images hub_versions hub_up

hub_down_volume:
	docker-compose down --volume;

hub_clean: hub_down_volume
	docker ps -a | grep o2r | awk '{print $$1}' | xargs sh -c "docker rm --force || true"
	docker images | grep o2r | awk '{print $$3}' | xargs sh -c "docker rmi --force || true"

local_clean: local_down_volume
	docker ps -a | grep o2r | awk '{print $$1}' | xargs sh -c "docker rm --force || true"
	docker images | grep o2r_refimpl | awk '{print $$3}' | xargs sh -c "docker rmi --force || true"

build_documentation:
	rm -f *.pdf
	docker build --tag o2r_refimpl_docbuilder --file etc/Dockerfile.documentations .
	docker run -it -v $(CURDIR)/architecture:/doc:rw o2r_refimpl_docbuilder make build pdf 
	docker run -it -v $(CURDIR)/api:/doc:rw o2r_refimpl_docbuilder make build pdf 
	docker run -it -v $(CURDIR)/erc-spec:/doc:rw o2r_refimpl_docbuilder make build travis_pdf
	mv architecture/site/o2r-architecture.pdf .
	mv erc-spec/site/erc-spec.pdf .
	mv api/o2r-web-api.pdf .
	@echo "ERC, architecture, and web API documentation created, see files PDF files in the project root directory"

local_save_images:
	docker save \
	mongo:3.6 \
	adicom/admin-mongo:latest \
	docker.elastic.co/elasticsearch/elasticsearch:5.6.10 \
	o2r_refimpl_containerit \
	o2r_refimpl_meta \
	o2r_refimpl_muncher \
	o2r_refimpl_loader \
	o2r_refimpl_informer \
	o2r_refimpl_bouncer \
	o2r_refimpl_finder \
	o2r_refimpl_transporter \
	o2r_refimpl_shipper \
	o2r_refimpl_substituter \
	o2r_refimpl_inspecter \
	o2r_refimpl_bindings \
	o2r_refimpl_guestlister \
	o2r_refimpl_platform \
	nginx:latest | pigz --stdout --fast > o2r-reference-implementation-images.tar.gz;
	ls -1sh o2r-reference-implementation-images*.tar.gz;

#@echo "Inspect tarball manifests with";
#tar -xf o2r-reference-implementation-images.tar.gz manifest.json -O | python -m json.tool;
	
create_archives:
	zip -r -q o2r-reference-implementation-modules.zip containerit/ erc-checker/ o2r-*/;
	zip -r -q o2r-docs.zip api/ architecture/ erc-examples/ erc-spec/;
	zip -r -q o2r-reference-implementation-files.zip etc/ .env docker-compose*.yml LICENSE versions.txt;

versions:
	make --version;
	git --version;
	docker --version;
	docker-compose --version;
	pigz --version;
	python --version;
	unzip --help | head -1;
	zip --help | head -2 | tail -1;

package_clean:
	rm -f *.zip;
	rm -f *.tar;
	rm -f *.tar.gz;

package: package_clean \
	local_clean \
	versions \
	update \
	build_documentation \
	local_versions_save \
	local_build \
	local_save_images \
	create_archives

upload_files_to_zenodo:
	python etc/zenodo_upload.py
	
reproduce:
	unzip o2r-docs.zip;
	o2r-reference-implementation-modules.zip;
	unzip o2r-reference-implementation-files.zip;
	docker load --input o2r-reference-implementation-images.tar.gz;
	docker-compose --file docker-compose-local.yml --project-name reference-implementation up --no-build;
