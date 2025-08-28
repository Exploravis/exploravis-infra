variable "clusters" {
  description = "Map of cluster defs"
  type = map(object({
    cluster_name   = optional(string)
    region         = string
    worker_count   = number
    instance_size  = string
    disk_size      = number
    ssh_public_key = string
    admin_username = string
    tags           = optional(map(string), {})
  }))
}

