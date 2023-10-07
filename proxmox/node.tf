# WORKER NODES DEFINITION

resource "proxmox_vm_qemu" "worker_node" {

  # ****************************************************
  # ***************** Number of VM *********************
  count = var.worker_node_count

  # ****************************************************
  # ***************** Provision VM *********************
  # VM unique tag
  tags = "kube-worker"

  # VM General Settings
  target_node = var.node
  clone       = var.clone
  vmid        = 500 + (count.index + 1)
  name        = "VM-${500 + (count.index + 1)}"
  desc        = "Kubernetes worker node ${count.index + 1}"

  # VM Advanced General Settings
  onboot = true

  # VM System Settings
  agent   = 1
  os_type = "cloud-init"
  sockets = 1
  cores   = 2
  cpu     = "host"
  memory  = 6144

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
  ipconfig0 = "ip=192.168.1.5${count.index + 1}/24,gw=192.168.1.254"

  # VM Default User
  ciuser  = "kube"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
