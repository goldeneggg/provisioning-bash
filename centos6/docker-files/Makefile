OWNER := goldeneggg
OS := centos6

.DEFAULT_GOAL := build

build:
	@docker build -t $(OWNER):$(OS) .

build-local:
	@if [ -f ./entry.sh ]; then rm ./entry.sh; fi
	@if [ -d ./centos6 ]; then rm -fr ./centos6; fi
	@cp ../../entry.sh ./entry.sh
	@cp ../../entry.sh ./entry.sh && mkdir ./centos6 && cp ../prepare.sh centos6/prepare.sh && cp -r ../envs centos6/ && cp -r ../files centos6/ && \
		cp ../init.sh centos6/init.sh
	@docker build -t $(OWNER):$(OS) -f Dockerfile.local .

.PHONY: test
test:
	@docker run --rm $(OWNER):$(OS) /bin/sh -c "date | grep JST > /dev/null"
