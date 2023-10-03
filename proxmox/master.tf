# MASTER NODES DEFINITION

resource "proxmox_vm_qemu" "master_node" {

  # ****************************************************
  # ***************** Number of VM *********************
  count = var.master_node_count

  # ****************************************************
  # ***************** Provision VM *********************
  # VM unique tag
  tags = "kube-master"

  # VM General Settings
  target_node = var.node
  clone       = var.clone
  vmid        = 400 + (count.index + 1)
  name        = "VM-${400 + (count.index + 1)}"
  desc        = "Kubernetes master node ${count.index + 1}"

  # VM Advanced General Settings
  onboot = true

  # VM System Settings
  agent   = 1
  os_type = "cloud-init"
  sockets = 1
  cores   = 2
  cpu     = "host"
  memory  = 3072

  # VM Storage Settings
  disk {
    size     = "40G"
    format   = "raw"
    storage  = "local-lvm"
    type     = "virtio"
    iothread = 1
    discard  = "on"
  }

  # VM Network Settings
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }
  ipconfig0 = "ip=192.168.1.4${count.index + 1}/24,gw=192.168.1.254"

  # VM Default User
  ciuser  = "kube"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
