output "master_ip" {
  value = module.master.public_ip
}

output "worker_ips" {
  value = [for worker in module.workers : worker.public_ip]
}

