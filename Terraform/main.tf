resource "proxmox_vm_qemu" "pm-vm-master" {
  count = var.num_k3s_master
  name = "k3s-master-${count.index+1}"
  target_node = var.pm_nodename
  vmid = 301 + count.index
  desc = "K3s master-${count.index+1}"

  clone = var.template_vm_name
  full_clone = true

  cicustom = "user=Storage-nvme256:snippets/userconfig.yml"
  cloudinit_cdrom_storage = "Storage-nvme256"

  agent = 1
  memory = var.num_k3s_master_memory
  cores = 2
  qemu_os = "l26"
  scsihw = "virtio-scsi-pci"
  boot = "order=scsi0"
  os_type = "cloud-init"
  ipconfig0 = "ip=${var.master_ips[count.index]}/${var.network_range},gw=${var.gateway}"
 
  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  disk {
    type = "scsi"
    storage = "local-lvm"
    size = "24G"
    ssd = 1
  }

  lifecycle {
    ignore_changes = [ network ]
  }
}

resource "proxmox_vm_qemu" "pm-vm-worker" {
  count = var.num_k3s_worker
  name = "k3s-worker-${count.index+1}"
  target_node = var.pm_nodename
  vmid = 310 + count.index
  desc = "K3s worker-${count.index+1}"

  clone = var.template_vm_name
  full_clone = true

  cicustom = "user=Storage-nvme256:snippets/userconfig.yml"
  cloudinit_cdrom_storage = "Storage-nvme256"
  
  agent = 1
  memory = var.num_k3s_worker_memory
  cores = 1
  qemu_os = "l26"
  scsihw = "virtio-scsi-pci"
  boot = "order=scsi0"
  os_type = "cloud-init"
  ipconfig0 = "ip=${var.worker_ips[count.index]}/${var.network_range},gw=${var.gateway}"

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  disk {
    type = "scsi"
    storage = "Storage-nvme256"
    size = "24G"
    ssd = 1
  }

  lifecycle {
     ignore_changes = [ network ]
  }
}