#! /bin/sh

packer init .

packer build --var-file=variables.pkrvars.hcl .