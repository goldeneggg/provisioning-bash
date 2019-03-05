OWNER := goldeneggg
OS := amazon2

.DEFAULT_GOAL := build

build:
	@docker build -t $(OWNER):$(OS) .

build-local:
	@if [ -f ./entry.sh ]; then rm ./entry.sh; fi
	@if [ -d ./amazon1 ]; then rm -fr ./amazon1; fi
	@cp ../../entry.sh ./entry.sh && mkdir ./amazon2 && cp ../../amazon1/prepare.sh amazon2/prepare.sh && cp -r ../../amazon1/envs amazon2/ && cp -r ../../amazon1/files amazon2/ && \
		cp ../../amazon1/init.sh amazon2/init.sh
	@docker build -t $(OWNER):$(OS) -f Dockerfile.local .

.PHONY: test
test:
	@docker run --rm $(OWNER):$(OS) /bin/sh -c "date | grep JST > /dev/null"
