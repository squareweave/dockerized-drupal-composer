DOCKER := docker
VERSIONS ?= 8

generate: clean
	$(DOCKER) run -ti -v $(PWD):/source -w /source debian:jessie bash update.sh ${VERSIONS}

clean:
	rm -rf ${VERSIONS}