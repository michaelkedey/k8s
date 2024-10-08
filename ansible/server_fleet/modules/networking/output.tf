#vpc_id
output "vpc_id" {
  value = aws_vpc.ansible_vpc.id
}

#subnet_ids
output "sn_private1_id" {
  value = aws_subnet.sn_private1.id
}

output "sn_private2_id" {
  value = aws_subnet.sn_private2.id
}

output "sn_public1_id" {
  value = aws_subnet.sn_public1.id
}

output "sn_public2_id" {
  value = aws_subnet.sn_public2.id
}

output "control_sg" {
  value = aws_security_group.ansible_control_node_sg.id
}

output "slaves_sg" {
  value = aws_security_group.ansible_slave_node_sg.id
}

# output "lb_url" {
#   value = aws_lb.ansible_lb.dns_name
# }

