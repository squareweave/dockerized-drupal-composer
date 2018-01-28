DOCKER := docker
GIT := git
VERSIONS ?= 8.4
BUILD_DIRECTORY = build
MAIN_BRANCH = master
COMMIT_ID ?= $(shell git rev-parse --short HEAD)
TEMPLATE_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

all: checkout clean generate commit

checkout:
	rm -rf ${BUILD_DIRECTORY}
	$(GIT) fetch origin ${MAIN_BRANCH}
	$(GIT) clone --branch ${MAIN_BRANCH} . ${BUILD_DIRECTORY}

generate:
	$(DOCKER) run --rm -ti -v $(PWD):/source -v $(PWD)/${BUILD_DIRECTORY}:/build -w /source debian:jessie bash \
		update.sh ${VERSIONS}

clean:
	rm -rf ${BUILD_DIRECTORY}/${VERSIONS}

commit:
	cd ${BUILD_DIRECTORY} && $(GIT) add .
	cd ${BUILD_DIRECTORY} && $(GIT) commit -m "Update based on commit ${COMMIT_ID} in branch ${TEMPLATE_BRANCH}"
	cd ${BUILD_DIRECTORY} && $(GIT) push origin ${MAIN_BRANCH}

update:
	$(DOCKER) pull squareweave/dockerized-drupal-composer:${VERSIONS}
	$(DOCKER) run --rm -ti \
		-v $(PWD)/templates/app/composer.json:/app/composer.json \
		-v $(PWD)/templates/app/composer.lock:/app/composer.lock \
		-w /app \
		squareweave/dockerized-drupal-composer:${VERSIONS} composer update \
			--no-plugins --no-autoloader --no-scripts --prefer-stable ${VERBOSITY}

builder:
	$(DOCKER) build -t squareweave/dockerized-drupal-composer:${VARIANT} ${PATH}

build-apache:
	$(MAKE) builder VARIANT=8 PATH=8

build-fpm:
	$(MAKE) builder VARIANT=8-fpm PATH=8/fpm

build-node:
	$(MAKE) builder VARIANT=8-node PATH=8/node
	$(MAKE) builder VARIANT=8-fpm-node PATH=8/fpm/node

build: build-apache build-fpm build-node