OWNER := goldeneggg
OS := alpine3.10

.DEFAULT_GOAL := build

.PHONY: build
build:
	@docker build -t $(OWNER):$(OS) .

# Note:
build-local:
	@if [ -f ./entry.sh ]; then rm ./entry.sh; fi
	@if [ -d ./alpine3 ]; then rm -fr ./alpine3; fi
	@cp ../../entry.sh ./entry.sh
	@cp ../../entry.sh ./entry.sh && mkdir ./alpine3 && cp ../prepare.sh alpine3/prepare.sh && cp -r ../envs alpine3/ && cp -r ../files alpine3/ && \
		cp ../init.sh alpine3/init.sh
	@docker build -t $(OWNER):$(OS) -f Dockerfile.local .

.PHONY: test
test:
	@docker run --rm $(OWNER):$(OS) /bin/sh -c "date | grep JST > /dev/null"
