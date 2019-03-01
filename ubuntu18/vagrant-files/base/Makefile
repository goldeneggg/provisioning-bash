SSH_CONF := ~/.ssh/config_vag

.DEFAULT_GOAL := up

.PHONY :up
up:
	@vagrant up

.PHONY :init
init:
	@vagrant up --provision && vagrant reload

add-sshconf:
	@vagrant ssh-config >> $(SSH_CONF)

.PHONY :halt
halt:
	@vagrant halt

.PHONY :destroy
destroy:
	@vagrant destroy

