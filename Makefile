.PHONY: all install build import deploy forward clean

all: install build import deploy forward

install:
	@echo ">> Installation de Packer et Ansible..."
	wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $$(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
	sudo apt-get update && sudo apt-get install -y packer
	pip install ansible kubernetes --break-system-packages
	ansible-galaxy collection install kubernetes.core

build:
	@echo ">> Build image avec Packer..."
	packer init packer.pkr.hcl
	packer build packer.pkr.hcl

import:
	@echo ">> Import image dans K3d..."
	k3d image import custom-nginx:latest -c lab

deploy:
	@echo ">> Déploiement via Ansible..."
	ansible-playbook ansible/deploy.yml

forward:
	@echo ">> Forward port 8081..."
	kubectl port-forward svc/custom-nginx-svc 8081:80 >/tmp/nginx.log 2>&1 &

clean:
	@echo ">> Suppression..."
	kubectl delete deployment custom-nginx
	kubectl delete svc custom-nginx-svc
