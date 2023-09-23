# automated-kubernetes-proxmox

## Project Overview

The purpose of this project is to automate the provisioning of an HA Kubernetes clusters on Proxmox.

The project focuses on infrastructure provisioning with Terraform and k3s configuration with metallb, kube-vip and longhorn using Ansible. The project also includes a Packer template for creating custom VM images on Proxmox, and a Terraform module for deploying istio and portainer on the k3s cluster with Helm.

The Ansible playbook is a fork from [k3s-ansible](https://github.com/techno-tim/k3s-ansible).

## Project Structure

The project is organized into the following directories:

- **app-deployments:**
Terraform module for deploying istio and portainer on the k3s cluster with Helm.

- **configuration-vm-k3s-kube-metallb:**
Ansible playbook for k3s configuration with metalLB, kube-vip and longhorn.

- **packer-template-vm-proxmox:**
Packer templates for creating custom virtual machine images on Proxmox.

- **provision-clone-vm-proxmox:**
Terraform module for provisioning worker and master nodes from cloning an existing template.

## Getting Started

### Template Creation

If you want to create a custom template for your VMs, you can use the Packer template in the packer-template-vm-proxmox directory. For that, you need to install Packer. Then, inside the packer-template-vm-proxmox directory, you need to create a variables.pkrvars.hcl file with the following content:
```
proxmox_api_url          = "https://<PROXMOX_IP>:8006/api2/json"
proxmox_api_token_id     = "<PROXMOX_TOKEN_ID>"
proxmox_api_token_secret = "<PROXMOX_TOKEN_SECRET>"
```
And, don't forget to add your SSH key to `packer-template-vm-proxmox/http/user-data`.

Install the providers:
```
$ packer init .
```

Create the template:
```
$ packer build --var-file=variables.pkrvars.hcl .
```

### Infrastructure Provisioning

To provision the infrastructure, you need to install Terraform. And then inside the provision-clone-vm-proxmox directory, you need to create a terraform.tfvars file with the following content:
```
proxmox_api_url          = "https://<PROXMOX_IP>:8006/api2/json"
proxmox_api_token_id     = "<PROXMOX_TOKEN_ID>"
proxmox_api_token_secret = "<PROXMOX_TOKEN_SECRET>"
node                     = "<PROXMOX_NODE>"
clone                    = "<PROXMOX_TEMPLATE>"
ssh_key                  = "<SSH_KEY>"
```

Install the providers:
```
$ terraform init
```

Create the infrastructure:
```
$ terraform apply --auto-approve
```

### Kubernetes Configuration

To configure the k3s cluster, you need to install Ansible. The inventory will be automatically updated by the Terraform plan, and all configurations can be done inside this configuration [file](configuration-vm-k3s-kube-metallb/inventory/my-cluster/group_vars/all.yml).

If you want to use the Ansible playbook to configure the k3s cluster without provisioning the infrastructure with Terraform, you need to update the inventory file at `configuration-vm-k3s-kube-metallb/inventory/my-cluster/hosts.ini` with the following content:
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
> The playbook will save the kubeconfig file at the place defined in the configuration [file](configuration-vm-k3s-kube-metallb/inventory/my-cluster/group_vars/all.yml).

### Application Deployments

Currently, this folder only deploys istio and portainer on the k3s cluster with Helm. However, feel free to add more modules.

Install the providers:
```
$ terraform init
```

Create the infrastructure:
```
$ terraform apply --auto-approve
```