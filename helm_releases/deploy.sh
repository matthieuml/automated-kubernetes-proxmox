#! /bin/sh

if [ "$1" = "-auto-approve" ]; then
    AUTO_APPROVE="$1"
else
    AUTO_APPROVE=""
fi

# Deploy basics helm charts
terraform -chdir=helm_releases init && terraform -chdir=helm_releases apply $AUTO_APPROVE