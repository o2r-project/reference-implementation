init:
	git clone https://github.com/o2r-project/reference-implementation
	cd reference-implementation
	git submodule add https://github.com/o2r-project/api
	git submodule add https://github.com/o2r-project/architecture
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

update:
	git pull --recurse-submodules
	git submodule update --init --recursive --remote
	git submodule foreach git pull origin master

local_images:
	cd o2r-bouncer; 	docker build --tag o2r_refimpl_bouncer 		.; cd ..;
	cd o2r-finder; 		docker build --tag o2r_refimpl_finder 		.; cd ..;
	cd o2r-informer; 	docker build --tag o2r_refimpl_informer 	.; cd ..;
	cd o2r-inspecter; 	docker build --tag o2r_refimpl_inspecter 	.; cd ..;
	cd o2r-loader; 		docker build --tag o2r_refimpl_loader 		.; cd ..;
	cd o2r-meta; 		docker build --tag o2r_refimpl_meta			.; cd ..;
	cd o2r-muncher; 	docker build --tag o2r_refimpl_muncher 		.; cd ..;
	cd o2r-platform; 	docker build --tag o2r_refimpl_platform 	.; cd ..;
	cd o2r-shipper; 	docker build --tag o2r_refimpl_shipper 		.; cd ..;
	cd o2r-substituter; docker build --tag o2r_refimpl_substituter 	.; cd ..;
	cd o2r-transporter; docker build --tag o2r_refimpl_transporter 	.; cd ..;
	cd o2r-guestlister; docker build --tag o2r_refimpl_guestlister 	.; cd ..;
	cd o2r-bindings; 	docker build --tag o2r_refimpl_bindins	 	.; cd ..;

local_up:
	docker-compose --file docker-compose-local.yml up;

local_down:
	docker-compose --file docker-compose-local.yml down;

local: local_images local_versions local_up

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

hub: hub_images hub_versions hub_up

hub_down_volume:
	docker-compose down --volume;

hub_images:
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

clean: hub_down_volume
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

release: update build_documentation
	# TODO build all images, export them to files

reproduce:
	# TODO import images from files
	# run make local
	# deploy some examples
