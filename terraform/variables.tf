variable "clusters" {
  description = "Map of cluster defs"
  type = map(object({
    cluster_name = optional(string)
    region       = string
    # worker_count   = number
    # instance_size  = string
    # disk_size      = number
    admin_username = string
    workers = list(object({
      name          = string
      instance_size = string
      disk_size     = number
      count         = number
      tags          = optional(map(string), {})
    }))
    tags = optional(map(string), {})
  }))
}

