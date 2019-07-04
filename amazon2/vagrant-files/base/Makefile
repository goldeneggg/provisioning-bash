PUB_KEY := id_rsa.pub
SSH_CONF := ~/.ssh/config_vag
VAG_HOST = $(eval VAG_HOST := $(shell vagrant status | awk 'NR == 3 {print $$1}'))$(VAG_HOST)

.DEFAULT_GOAL := up

.PHONY: up
up:
	@PUB_KEY=$(PUB_KEY) vagrant up

.PHONY: init
init:
	@PUB_KEY=$(PUB_KEY) vagrant up --provision && vagrant reload

add-sshconf:
	@vagrant ssh-config >> $(SSH_CONF)
	@echo "  ForwardAgent yes" >> $(SSH_CONF)

host:
	@echo $(VAG_HOST)

# Note:
# - ssh-agent zsh
#   ssh-add ~/.ssh/id_rsa
ssh:
	@ssh -F $(SSH_CONF) -A $(VAG_HOST)

.PHONY: halt
halt:
	@vagrant halt

.PHONY: destroy
destroy:
	@vagrant destroy -f

