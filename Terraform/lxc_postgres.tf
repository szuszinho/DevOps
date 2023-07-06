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
  ssh_public_keys = <<-EOT
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTdHVoepiv/XsNujNjyOThQy7qu9lDxJvwbGZhEED6UcpEj3wHU80I/RGicbFbgsZhtit7Xr1R64wSMh5XyR4XukvKZ/E/mP5ife89+rC9hCLZwGrVwP/xYCcxJC0FYufYzvkoekdxHIaU6pHQTRSXvK0R1nL+fnQcLtVeGQw2G7FOZnSJqB1Xj2cMARKz/1tlWHy0tyWtkEPCeR2eHrsXZXQvmv+FuPO7wYJxElNlB6s10Kywd9m+jm9KprKddxRLYZGSavDi1OqGB+SRIuedH/0Cg+hwSlll8IRp9aFwvL1U6v4AT+SSoY8gAne6WBDyVjTplgJzLVm2/K9SCBwqhHssqeezBdlwCmwFb48ycQ0en3kDAtH/cGxUmxgr4GMJZPUcPsX3swJ2RrJnu/HXdcZViXM/bRGMuCi04yHpvjTTKuNt/g+IV2ZsI6arKDBPFe6wPNtwAenfq1QXo/SwL4cMV5oZaNRPQ1tmMRQ5JyCyIQ95oD7z7AXADI49uZM= szuszi@Win10-PC
  EOT

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