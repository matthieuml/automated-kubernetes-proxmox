packer {

  required_version = ">= 1.9.4"

  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}
