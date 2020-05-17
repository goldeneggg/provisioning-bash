OWNER := goldeneggg
OS := ubuntu20.04

.DEFAULT_GOAL := build

.PHONY: build
build:
	@docker build -t $(OWNER):$(OS) .

# Note:
# envs and files are symlink from ubuntu16
build-local:
	@if [ -f ./entry.sh ]; then rm ./entry.sh; fi
	@if [ -d ./ubuntu20 ]; then rm -fr ./ubuntu20; fi
	@cp ../../entry.sh ./entry.sh
	@cp ../../entry.sh ./entry.sh && mkdir ./ubuntu20 && cp ../prepare.sh ubuntu20/prepare.sh && cp -r ../../ubuntu16/envs ubuntu20/ && cp -r ../../ubuntu16/files ubuntu20/ && \
		cp ../init.sh ubuntu20/init.sh
	@docker build -t $(OWNER):$(OS) -f Dockerfile.local .

.PHONY: test
test:
	@docker run --rm $(OWNER):$(OS) /bin/sh -c "date | grep JST > /dev/null"
