OWNER := goldeneggg
OS := ubuntu18.04

.DEFAULT_GOAL := build

.PHONY: build
build:
	@docker build -t $(OWNER):$(OS) .

# Note:
# envs and files are symlink from ubuntu16
build-local:
	@if [ -f ./entry.sh ]; then rm ./entry.sh; fi
	@if [ -d ./ubuntu18 ]; then rm -fr ./ubuntu18; fi
	@cp ../../entry.sh ./entry.sh
	@cp ../../entry.sh ./entry.sh && mkdir ./ubuntu18 && cp ../prepare.sh ubuntu18/prepare.sh && cp -r ../../ubuntu16/envs ubuntu18/ && cp -r ../../ubuntu16/files ubuntu18/ && \
		cp ../init.sh ubuntu18/init.sh
	@docker build -t $(OWNER):$(OS) -f Dockerfile.local .

.PHONY: test
test:
	@docker run --rm $(OWNER):$(OS) /bin/sh -c "date | grep JST > /dev/null"
