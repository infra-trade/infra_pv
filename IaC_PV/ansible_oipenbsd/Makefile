.PHONY: deps template convert provision configure all

deps:
	ansible-galaxy collection install -r collections/requirements.yml --force

template:
	ansible-playbook playbooks/00-build-template.yml --ask-vault-pass

convert:
	ansible-playbook playbooks/01-convert-to-template.yml --ask-vault-pass

provision:
	ansible-playbook playbooks/02-provision-from-template.yml --ask-vault-pass

configure:
	ansible-playbook playbooks/03-configure.yml

all: deps template convert provision configure
