output "fleet_private_ips" {
    value = { for instance in aws_instance.server_fleet : instance.private_ip => instance.private_ip }
}

output "fleet_ids"{
  value = {for instance in aws_instance.server_fleet : instance.id => instance}

}