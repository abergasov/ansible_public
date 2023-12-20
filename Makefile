DOCKER_CONTAINER_NAME="ansible-test"
CLIENT_NAME ?= $(shell bash -c 'read -p "Client: " username; echo $$username')

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deps:
	ansible-galaxy install gantsign.oh-my-zsh

list: ## show all available hosts
	ansible all --list-hosts -i ./hosts.ini

ping: ## ping hosts
	ansible all -i ./hosts.ini -m ping

#test: docker_up ## test connection
test: ## test connection
	ansible-playbook -i ./docker/hosts.ini playbook.yml --vault-password-file=vault.txt

edit_secret: ## edit secret
	ansible-vault edit ./secret

run: deps ## run playbook
	ansible-playbook -i ./hosts.ini playbook.yml --vault-password-file=vault.txt

update: ## update dependencies
	ansible-playbook -i ./hosts.ini update.yml --vault-password-file=vault.txt

gen_vpn: ## generate vpn config
	rm generate_vpn_conf/*.conf || true
	rm generate_vpn_conf/*.ovpn || true
	@clear
	@echo Username › $(USERNAME)
	ansible-playbook -i ./hosts.ini gen_vpn.yml --vault-password-file=vault.txt --extra-vars "client=${CLIENT_NAME}"

docker_up: docker_down
	cd docker && docker build -t ansible_test_ubuntu .
	#docker run -ti --privileged --name ${DOCKER_CONTAINER_NAME} -dp 5123:22 ansible_test_ubuntu
	docker run -itd --privileged --name ${DOCKER_CONTAINER_NAME} -dp 5123:22 ansible_test_ubuntu

docker_down:
	docker stop ${DOCKER_CONTAINER_NAME}; true
	docker rm ${DOCKER_CONTAINER_NAME}; true

test_bash:
	docker exec -it ${DOCKER_CONTAINER_NAME} bash

.PHONY: help