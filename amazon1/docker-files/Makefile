OWNER := goldeneggg
OS := amazon1

.DEFAULT_GOAL := build

build:
	@docker build -t $(OWNER):$(OS) .

build-local:
	@if [ -f ./entry.sh ]; then rm ./entry.sh; fi
	@if [ -d ./amazon1 ]; then rm -fr ./amazon1; fi
	@cp ../../entry.sh ./entry.sh
	@cp ../../entry.sh ./entry.sh && mkdir ./amazon1 && cp ../prepare.sh amazon1/prepare.sh && cp -r ../envs amazon1/ && cp -r ../files amazon1/ && \
		cp ../init.sh amazon1/init.sh
	@docker build -t $(OWNER):$(OS) -f Dockerfile.local .

.PHONY: test
test:
	@docker run --rm $(OWNER):$(OS) /bin/sh -c "date | grep JST > /dev/null"
