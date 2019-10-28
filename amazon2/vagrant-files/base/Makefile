PUB_KEY := id_rsa.pub
SSH_CONF := ~/.ssh/config_vag
VAG_HOST = $(eval VAG_HOST := $(shell vagrant status | awk 'NR == 3 {print $$1}'))$(VAG_HOST)

.DEFAULT_GOAL := up

.PHONY: up
up:
	@PUB_KEY=$(PUB_KEY) vagrant up

BRANCH := some-fixes

.PHONY: up-branch
up-branch:
	@PUB_KEY=$(PUB_KEY) BRANCH=$(BRANCH) vagrant up

.PHONY: init
init:
	@PUB_KEY=$(PUB_KEY) vagrant up --provision && vagrant reload

add-sshconf:
	@vagrant ssh-config >> $(SSH_CONF)
	@echo "  ForwardAgent yes" >> $(SSH_CONF)

.PHONY: host
host:
	@echo $(VAG_HOST)

# Note:
# - ssh-agent zsh
#   ssh-add ~/.ssh/id_rsa
.PHONY: ssh
ssh:
	@ssh -F $(SSH_CONF) -A $(VAG_HOST)

.PHONY: halt
halt:
	@vagrant halt

.PHONY: reload
reload:
	@vagrant reload

.PHONY: destroy
destroy:
	@vagrant destroy -f

