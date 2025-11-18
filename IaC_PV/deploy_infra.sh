#!/usr/bin/env bash
set -e

REPO_DIR="/home/pvinfra/infra_pv/IaC_PV"
INVENTORY="$REPO_DIR/ansible/inventories/infra/hosts.yml"
PLAY22="$REPO_DIR/ansible/playbooks/22_infra_replication_cdci.yml"

cd "$REPO_DIR"

echo "==== [$(date)] Comprobando cambios en Git ===="

# Asegurarnos de estar en la rama main
git checkout main >/dev/null 2>&1 || true

# Traer cambios del remoto
git fetch origin

LOCAL_HASH=$(git rev-parse HEAD)
REMOTE_HASH=$(git rev-parse origin/main)

if [ "$LOCAL_HASH" = "$REMOTE_HASH" ]; then
  echo "No hay cambios nuevos en origin/main. Nada que desplegar."
  exit 0
fi

echo "Cambios detectados. Haciendo git pull..."
git pull origin main

echo "Ejecutando Ansible playbook 22_infra_replication_cdci.yml..."
ansible-playbook -i "$INVENTORY" "$PLAY22" --ask-become-pass <<EOF
$BECOME_PASS
EOF
# NOTA: Si no quieres que pida contraseña sudo, configura sudo NOPASSWD para pvinfra
# y quita el --ask-become-pass

echo "==== [$(date)] Despliegue completado ===="