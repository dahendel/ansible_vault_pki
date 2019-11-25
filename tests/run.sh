#!/bin/bash
docker rm -f vault
docker run -d --name vault --cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=myroot' -e 'VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:1234' -p 1234:1234 vault

export VAULT_ADDR=http://localhost:1234
export VAULT_TOKEN=myroot

ansible-playbook certs.yaml
ansible-playbook certs.yaml -e remove_ca=true
