variable "cluster_name" {}
variable "region" {}
# variable "worker_count" {}
variable "admin_username" {}
variable "ssh_public_key" {}
# variable "disk_size" {}
# variable "instance_size" {}
variable "tags" {}
variable "workers" {
  description = "workers specs"
  type = list(object({
    name          = string
    instance_size = string
    disk_size     = number
    count         = number
    tags          = map(string)
  }))
}
