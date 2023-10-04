# automated-kubernetes-proxmox

## Project Overview

The purpose of this project is to automate the provisioning of an HA Kubernetes clusters on Proxmox.

The project focuses on infrastructure provisioning with Terraform and k3s configuration with metallb, kube-vip and longhorn using Ansible. The project also includes a Packer template for creating custom VM images on Proxmox, and a Terraform module for deploying some tools like istio on the k3s cluster with Helm.

The Ansible playbook is a fork from [k3s-ansible](https://github.com/techno-tim/k3s-ansible).

## Quickstart

### Requirements

- [Terraform](https://www.terraform.io/downloads.html)
- [Packer](https://www.packer.io/downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

### Usage

Provision the infrastructure and deploy the k3s cluster with some tools:
```
$ ./deploy.sh
```

> [!NOTE]
> Make sure to update all the variables defined for each module.

## Project Structure

The project is organized into the following directories:

- **helm_releases:**
Terraform module for deploying istio and portainer on the k3s cluster with Helm.

- **packer-image:**
Packer templates for creating custom virtual machine images on Proxmox.

- **proxmox:**
Terraform module for provisioning worker and master nodes from cloning an existing template. It includes the Ansible playbook for configuring the k3s cluster.

## Getting Started

### Template Creation

If you want to create a custom template for your VMs, you can use the Packer template in the `packer-image` directory. For that, you need to install Packer. Then, you need to create a variables.pkrvars.hcl file with the following content:
```
proxmox_api_url          = "https://<PROXMOX_IP>:8006/api2/json"
proxmox_api_token_id     = "<PROXMOX_TOKEN_ID>"
proxmox_api_token_secret = "<PROXMOX_TOKEN_SECRET>"
ssh_key                  = "<SSH_KEY>"
```

> [!NOTE]
> Don't forget to open the firewall for the autoinstall process which uses an http server.

Install the providers and create the template:
```
$ ./packer-image/build.sh
```

### Infrastructure Provisioning

To provision the infrastructure, you need to install Terraform. And then inside the `proxmox` directory, you need to create a terraform.tfvars file with the following content:
```
proxmox_api_url          = "https://<PROXMOX_IP>:8006/api2/json"
proxmox_api_token_id     = "<PROXMOX_TOKEN_ID>"
proxmox_api_token_secret = "<PROXMOX_TOKEN_SECRET>"
node                     = "<PROXMOX_NODE>"
clone                    = "<PROXMOX_TEMPLATE>"
ssh_key                  = "<SSH_KEY>"
```

Install the providers and provision the infrastructure:
```
$ ./proxmox/deploy.sh
```

### Kubernetes Configuration

To configure the k3s cluster, you need to install Ansible. The inventory will be automatically updated by the Terraform plan, and all configurations can be done inside this configuration [file](proxmox/k3s-configuration/inventory/my-cluster/group_vars/all.yml).

If you want to use the Ansible playbook to configure the k3s cluster without provisioning the infrastructure with Terraform, you need to update the inventory file at `proxmox/k3s-configuration/inventory/my-cluster/hosts.ini` with the following content:
```
[master]
<MASTER_IP>

[worker]
<WORKER_IP>

[k3s_cluster:children]
master
node
```

Then, you can execute the playbook:
```
$ ansible-playbook -i inventory playbook.yml
```

> [!WARNING]
> The playbook will save the kubeconfig file at the place defined in the configuration [file](configuration-vm-k3s-kube-metallb/inventory/my-cluster/group_vars/all.yml). This will delete any previous kubeconfig file.

### Application Deployments

Currently, this folder only deploys a few tools like Istio on the k3s cluster with Helm. However, feel free to add more.

Install the providers and provision the infrastructure:
```
$ ./helm_releases/deploy.sh
```