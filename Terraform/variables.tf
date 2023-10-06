variable "pm_host" {
    description = "Proxmox server IP or hostname"
    type = string
}
variable "pm_nodename" {
  description = "Name of the Proxmox server"
  type = string
}
variable "pm_api_token_id" {
  description = "Proxmox user token ID"
  type = string
}
variable "pm_api_token_secret" {
  description = "Proxmox user token secret"
  type = string
  sensitive = true
}
variable "pm_tls_insecure" {
  description = "Set true to ignore certification errors"
  type = bool
  default = false
}
variable "num_k3s_master" {
  default = 1
}
variable "num_k3s_master_memory" {
  default = "2048"
}
variable "num_k3s_worker" {
  default = 3
}
variable "num_k3s_worker_memory" {
  default = "1024"
}
variable "template_vm_name" {}
variable "master_ips" {
  description = "List of K3s master nodes IPs"
}
variable "worker_ips" {
  description = "List of K3s worker nodes IPs"
}
variable "network_range" {
  description = "IP address range"
  default = 24
}
variable "gateway" {}

variable "public_key" {
  description = "SSH public key"
  type = string
  #sensitive = true
}