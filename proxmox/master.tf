# MASTER NODES DEFINITION

resource "proxmox_vm_qemu" "master_node" {

  # ****************************************************
  # ***************** Number of VM *********************
  count = var.master_node_count

  # ****************************************************
  # ***************** Provision VM *********************
  # VM General Settings
  target_node = var.node
  clone       = var.clone
  vmid        = 400 + (count.index + 1)
  name        = "VM-${400 + (count.index + 1)}"
  desc        = "Kubernetes master node ${count.index + 1}"
  tags        = "kube-master"

  # VM Boot Settings
  onboot  = true
  os_type = "cloud-init"

  # VM System Settings
  agent   = 1
  qemu_os = "other"
  sockets = 1
  cores   = 2
  cpu     = "host"
  memory  = 2500

  # VM Storage Settings
  scsihw = "virtio-scsi-single"
  disks {
    virtio {
      virtio0 {
        disk {
          size     = 40
          format   = "raw"
          storage  = "local-lvm"
          iothread = true
          discard  = true
        }
      }
    }
  }

  # VM Network Settings
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # VM Cloud Init
  cloudinit_cdrom_storage = "local-lvm"
  ciuser                  = "kube"
  sshkeys                 = <<EOF
  ${var.ssh_key}
  EOF
  ipconfig0               = "ip=192.168.254.4${count.index + 1}/24,gw=192.168.254.1"

  # Avoid recreating at each MAC address change
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}
