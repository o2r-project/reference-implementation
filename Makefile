init:
	git clone https://github.com/o2r-project/reference-implementation
	cd reference-implementation
	git submodule add https://github.com/o2r-project/o2r-bouncer
	git submodule add https://github.com/o2r-project/o2r-finder
	git submodule add https://github.com/o2r-project/o2r-informer
	git submodule add https://github.com/o2r-project/o2r-loader
	git submodule add https://github.com/o2r-project/o2r-meta
	git submodule add https://github.com/o2r-project/o2r-muncher
	git submodule add https://github.com/o2r-project/o2r-platform
	git submodule add https://github.com/o2r-project/o2r-shipper
	git submodule add https://github.com/o2r-project/o2r-substituter
	git submodule add https://github.com/o2r-project/o2r-transporter
	git submodule add https://github.com/o2r-project/o2r-web-api
	git submodule add https://github.com/o2r-project/erc-spec
	git submodule add https://github.com/o2r-project/erc-checker

update:
	git submodule update --init --recursive
	git submodule foreach git pull origin master

build_images:
	cd o2r-bouncer; 	docker build 	--tag bouncer -f Dockerfile.local --no-cache .; cd ..;
	cd o2r-finder; 		docker build 	--tag finder -f Dockerfile.local --no-cache .; cd ..;
	cd o2r-informer; 	docker build 	--tag informer -f Dockerfile --no-cache .; cd ..;
	cd o2r-loader; 		docker build 	--tag loader -f Dockerfile.local --no-cache .; cd ..;
	cd o2r-muncher; 	docker build 	--tag muncher -f Dockerfile.local --no-cache .; cd ..;
	cd o2r-platform; 	docker build 	--tag platform -f Dockerfile --no-cache .;  cd ..;
	cd o2r-shipper; 	docker build 	--tag shipper -f Dockerfile.local --no-cache .; cd ..;
	cd o2r-transporter; docker build 	--tag transporter -f Dockerfile --no-cache .;  cd ..;

run_local: pull_db_images;
	docker-compose --file docker-compose-db.yml up -d;
	sleep 10;
	OAUTH_CLIENT_ID=$O2R_ORCID_ID OAUTH_CLIENT_SECRET=$O2R_ORCID_SECRET OAUTH_URL_CALLBACK=$O2R_ORCID_CALLBACK ZENODO_TOKEN=$O2R_ZENODO_TOKEN docker-compose up;

stop_local:
	docker-compose --file docker-compose-db.yml down;
	docker-compose down;

run_hub: pull_hub_images run_hub_images

pull_db_images:
	docker pull mongo:3.4
	docker pull docker.elastic.co/elasticsearch/elasticsearch:5.6.3

pull_hub_images:
	docker pull o2rproject/o2r-bouncer;
	docker pull o2rproject/o2r-finder;
	docker pull o2rproject/o2r-informer;
	docker pull o2rproject/o2r-loader;
	docker pull o2rproject/o2r-muncher;
	docker pull o2rproject/o2r-platform;
	docker pull o2rproject/o2r-shipper;
	docker pull o2rproject/o2r-substituter;
	docker pull o2rproject/o2r-transporter;

run_hub_images:
	docker-compose --file docker-compose-db.yml up -d;
	sleep 10;
	docker-compose --file o2r-platform/test/docker-compose-hub.yml up;

show_microservices_versions:
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'	   o2rproject/o2r-bouncer;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'	    o2rproject/o2r-finder;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'      o2rproject/o2r-informer;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'        o2rproject/o2r-loader;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'       o2rproject/o2r-muncher;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'      o2rproject/o2r-platform;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.vcs-ref"}}'       o2rproject/o2r-shipper;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'   o2rproject/o2r-substituter;
	@docker inspect --format '{{index .Config.Labels "org.label-schema.name"}}: {{index .Config.Labels "org.label-schema.version"}}'   o2rproject/o2r-transporter;

clean:
	docker ps -a | grep o2r | awk '{print $1}' | xargs docker rm -f
	docker images | grep o2r | awk '{print $3}' | xargs docker rmi --force

release:
	git clone --recursive https://github.com/o2r-project/reference-implementation
	# TODO build all images, export them to files

reproduce:
	# TODO import images from files
