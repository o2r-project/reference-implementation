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
	git pull --recurse-submodules
	git submodule update --init --recursive --remote
	git submodule foreach git pull origin master

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
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.version"}}' o2r_refimpl_bouncer 	 ;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.version"}}' o2r_refimpl_finder 	 ;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.version"}}' o2r_refimpl_informer 	 ;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.version"}}' o2r_refimpl_inspecter 	 ;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.version"}}' o2r_refimpl_loader 	 ;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.version"}}' o2r_refimpl_meta 		 ;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.version"}}' o2r_refimpl_muncher 	 ;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.version"}}' o2r_refimpl_platform 	 ;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.vcs-ref"}}' o2r_refimpl_shipper 	 ;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.version"}}' o2r_refimpl_substituter ;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.version"}}' o2r_refimpl_transporter ;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.version"}}' o2r_refimpl_guestlister ;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.version"}}' o2r_refimpl_bindings    ;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}:	{{index .Config.Labels "org.label-schema.version"}}' o2r_refimpl_containerit ;

hub: hub_images hub_versions hub_up

hub_down_volume:
	docker-compose down --volume;

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

hub_up:
	docker-compose up;

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

clean: hub_down_volume local_down_volume
	docker ps -a | grep o2r | awk '{print $1}' | xargs docker rm -f
	docker images | grep o2r | awk '{print $3}' | xargs docker rmi --force

build_documentation:
	rm -f *.pdf
	docker build --tag docbuilder --file etc/Dockerfile.documentations .
	docker run -it -v $(CURDIR)/architecture:/doc:rw docbuilder make build pdf 
	docker run -it -v $(CURDIR)/api-spec:/doc:rw docbuilder make build pdf 
	docker run -it -v $(CURDIR)/erc-spec:/doc:rw docbuilder make build pdf_tinytex
	mv architecture/site/*.pdf .
	mv erc-spec/*.pdf .
	mv api-spec/*.pdf .
	echo "ERC, architecture, and web API documentation created, see files PDF files in the project root directory"

local_save_images:
	docker save \
	mongo:3.6 \
	adicom/admin-mongo:latest \
	docker.elastic.co/elasticsearch/elasticsearch:5.6.10 \
	o2r_refimpl_containerit \
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
	nginx:latest | gzip -c > o2r-reference-implementation-images.tar.gz;
	tar -tvf o2r-reference-implementation-images.tar.gz;
	ls -sh o2r-reference-implementation-images.tar.gz;
	@echo "Inspecting tarball manifest:";
	tar -xf o2r-reference-implementation-images.tar.gz manifest.json -O | python -m json.tool;

create_archive:
	zip -r -q o2r-reference-implementation-modules.zip software;
	zip -r -q o2r-docs.zip api/ architecture/ erc-examples/ erc-spec/;

reproduce:
	# TODO import images from files
	# run make local
	# deploy some examples
