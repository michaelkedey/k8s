output "master_public_ip" {
  value = module.master.master_public_ip
}

output "slave_private_ips" {
  value = module.server_fleet.fleet_private_ips
}