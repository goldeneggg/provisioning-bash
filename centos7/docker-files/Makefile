OWNER := goldeneggg
OS := centos7

.DEFAULT_GOAL := build

build:
	@docker build -t $(OWNER):$(OS) .

build-local:
	@if [ -f ./entry.sh ]; then rm ./entry.sh; fi
	@if [ -d ./centos7 ]; then rm -fr ./centos7; fi
	@cp ../../entry.sh ./entry.sh
	@cp ../../entry.sh ./entry.sh && mkdir ./centos7 && cp ../prepare.sh centos7/prepare.sh && cp -r ../envs centos7/ && cp -r ../files centos7/ && \
		cp ../init.sh centos7/init.sh
	@docker build -t $(OWNER):$(OS) -f Dockerfile.local .

.PHONY: test
test:
	@docker run --rm $(OWNER):$(OS) /bin/sh -c "date | grep JST > /dev/null"
