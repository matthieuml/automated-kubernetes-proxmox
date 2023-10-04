#! /bin/sh

if [ "$1" = "-auto-approve" ]; then
    AUTO_APPROVE="$1"
else
    AUTO_APPROVE=""
fi

# Deploy the infrastructure
terraform -chdir=proxmox init && terraform -chdir=proxmox apply $AUTO_APPROVE