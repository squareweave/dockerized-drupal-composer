DOCKER := docker
VERSIONS ?= 8

generate: clean
	$(DOCKER) run -ti -v $(PWD):/source -w /source debian:jessie bash update.sh ${VERSIONS}

clean:
	rm -rf ${VERSIONS}


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