clusters = {
  france = {
    cluster_name   = "france-cluster-1"
    region         = "francecentral"
    admin_username = "azureuser"
    workers = [
      {
        name          = "worker-group-1"
        instance_size = "Standard_B1ms"
        disk_size     = 30
        count         = 2
        tags          = { role = "ms1", owner = "exploravis-infra" }
      }
    ]
  }


}
