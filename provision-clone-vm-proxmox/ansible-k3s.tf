# CONFIGURATION DATA

locals {
  ansible_dir   = "../configuration-vm-k3s-kube-metallb"
  inventory_dir = "${local.ansible_dir}/inventory/my-cluster"
}

# ANSIBLE INVENTORY

data "template_file" "nodes_inventory" {
  template = file("${local.inventory_dir}/hosts.tpl")
  vars = {
    master_nodes_ip = join("\n", proxmox_vm_qemu.master_node.*.default_ipv4_address)
    worker_nodes_ip = join("\n", proxmox_vm_qemu.worker_node.*.default_ipv4_address)
  }
}

# ANSIBLE PLAYBOOK

resource "local_file" "nodes_inventory" {
  content  = data.template_file.nodes_inventory.rendered
  filename = "${local.inventory_dir}/hosts.ini"

  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=${local.ansible_dir}/ansible.cfg ansible-playbook -i ${local_file.nodes_inventory.filename} ${local.ansible_dir}/site.yml"
  }
}