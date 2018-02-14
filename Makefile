init:
	git clone https://github.com/o2r-project/reference-implementation
	cd reference-implementation
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
	git submodule add https://github.com/o2r-project/o2r-web-api

update:
	git pull --recurse-submodules
	git submodule update --init --recursive --remote
	git submodule foreach git pull origin master

build_images:
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

run_local:
	OAUTH_CLIENT_ID=$(value O2R_ORCID_ID) OAUTH_CLIENT_SECRET=$(value O2R_ORCID_SECRET) OAUTH_URL_CALLBACK=$(value O2R_ORCID_CALLBACK) ZENODO_TOKEN=$(value O2R_ZENODO_TOKEN) docker-compose --file docker-compose-local.yml up;

stop_local:
	docker-compose --file docker-compose-local.yml down;

show_versions_local:
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

run_hub: pull_hub_images run_hub_images

stop_hub:
	docker-compose down;

pull_hub_images:
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

run_hub_images:
	OAUTH_CLIENT_ID=$(value O2R_ORCID_ID) OAUTH_CLIENT_SECRET=$(value O2R_ORCID_SECRET) OAUTH_URL_CALLBACK=$(value O2R_ORCID_CALLBACK) ZENODO_TOKEN=$(value O2R_ZENODO_TOKEN) docker-compose up;

show_versions_hub:
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

clean_containers_and_images:
	docker ps -a | grep o2r | awk '{print $1}' | xargs docker rm -f
	docker images | grep o2r | awk '{print $3}' | xargs docker rmi --force

build_documentation:
	rm -f *.pdf
	docker build --tag docbuilder --file etc/Dockerfile.documentations .
	docker run -it -v $(CURDIR)/architecture:/doc:rw docbuilder make build pdf 
	docker run -it -v $(CURDIR)/o2r-web-api:/doc:rw docbuilder  make build pdf 
	docker run -it -v $(CURDIR)/erc-spec:/doc:rw     docbuilder make build pdf_tinytex
	mv architecture/site/*.pdf .
	mv erc-spec/*.pdf .
	mv o2r-web-api/*.pdf .
	echo "ERC, architecture, and web API documentation created, see files PDF files in the project root directory"

release: update build_documentation
	# TODO build all images, export them to files

reproduce:
	# TODO import images from files
