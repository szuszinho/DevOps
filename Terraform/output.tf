output "Master-IPS" {
  value = ["${proxmox_vm_qemu.pm-vm-master.*.default_ipv4_address}"]
}

output "Worker-IPS" {
  value = ["${proxmox_vm_qemu.pm-vm-worker.*.default_ipv4_address}"]
}

output "Postgres-IP" {
  value = ["${proxmox_lxc.db_postgres.network[0].ip}"]
}