variable "pswd" {
  description = "Container admin password"
  type = string
  sensitive = true
}

variable "lxc_ip" {
  description = "Container IP address"
  type = string
}

resource "proxmox_lxc" "db_postgres" {
  description = "Postgres LXC container for K3s etcd"
  target_node = var.pm_nodename
  hostname = "postgres"
  ostemplate = "local:vztmpl/debian-11-turnkey-postgresql_17.1-1_amd64.tar.gz"
  password = var.pswd
  unprivileged = true
  cores = 3
  memory = 4096
  onboot = true
  start = true
  swap = 0
  tags = "Postgres K3s etcd"
  vmid = 399
  ssh_public_keys = ""

  rootfs {
    storage = "storage"
    size = "8G"
  }

  network {
    name = "eth0"
    bridge = "vmbr0"
    ip = var.lxc_ip
    gw = var.gateway
  }
}