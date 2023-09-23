variable "proxmox_api_url" {
  type        = string
  description = "The URL to the Proxmox API."
}

variable "proxmox_api_token_id" {
  type        = string
  sensitive   = true
  description = "The Proxmox API token ID for authentication."
}

variable "proxmox_api_token_secret" {
  type        = string
  sensitive   = true
  description = "The secret associated with the Proxmox API token."
}

variable "node" {
  type        = string
  description = "The target Proxmox node where VMs will be deployed."
}

variable "clone" {
  type        = string
  description = "The name of the Proxmox template or VM to clone for creating new VMs."
}

variable "ssh_key" {
  type        = string
  sensitive   = true
  description = "The SSH public key to inject into VMs for remote access."
}

variable "master_node_count" {
  type        = number
  description = "The number of Kubernetes master nodes to create."
}

variable "worker_node_count" {
  type        = number
  description = "The number of Kubernetes worker nodes to create."
}
