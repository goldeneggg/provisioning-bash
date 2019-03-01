OWNER := goldeneggg
OS := ubuntu18.04

.DEFAULT_GOAL := build

build:
	@docker build -t $(OWNER):$(OS) .

build-local:
	@if [ -f ./entry.sh ]; then rm ./entry.sh; fi
	@if [ -d ./ubuntu18 ]; then rm -fr ./ubuntu18; fi
	@cp ../../entry.sh ./entry.sh
	@cp ../../entry.sh ./entry.sh && mkdir ./ubuntu18 && cp ../prepare.sh ubuntu18/prepare.sh && cp -r ../envs ubuntu18/ && cp -r ../files ubuntu18/ && \
		cp ../init.sh ubuntu18/init.sh
	@docker build -t $(OWNER):$(OS) -f Dockerfile.local .
