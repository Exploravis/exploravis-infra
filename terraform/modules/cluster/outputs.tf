output "master" {
  value = {
    name      = module.master.vm_name
    public_ip = module.master.public_ip
  }
}

output "workers" {
  value = [
    for w in module.workers : {
      name      = w.vm_name
      public_ip = w.public_ip
    }
  ]
}
