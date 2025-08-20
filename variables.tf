variable "az_instance_size" {
  description = "azure instance_type"
  type        = string
  default     = "Standard_B1ls"
}

variable "az_disk_size" {
  description = "azure disk size"
  type        = number
  default     = 30
}
