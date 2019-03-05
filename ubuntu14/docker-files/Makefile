OWNER := goldeneggg
OS := ubuntu14.04

.DEFAULT_GOAL := build

build:
	@docker build -t $(OWNER):$(OS) .

build-local:
	@if [ -f ./entry.sh ]; then rm ./entry.sh; fi
	@if [ -d ./ubuntu14 ]; then rm -fr ./ubuntu14; fi
	@cp ../../entry.sh ./entry.sh
	@cp ../../entry.sh ./entry.sh && mkdir ./ubuntu14 && cp ../prepare.sh ubuntu14/prepare.sh && cp -r ../envs ubuntu14/ && cp -r ../files ubuntu14/ && \
		cp ../init.sh ubuntu14/init.sh
	@docker build -t $(OWNER):$(OS) -f Dockerfile.local .

.PHONY: test
test:
	@docker run --rm $(OWNER):$(OS) /bin/sh -c "date | grep JST > /dev/null"
