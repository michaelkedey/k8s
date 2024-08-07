#vpc_id
output "vpc_id" {
  value = aws_vpc.eks_vpc.id
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

# output "backend_sg" {
#   value = aws_security_group.eks_db_nodes_sg.id
# }

# output "backend_sg_name" {
#   value = aws_security_group.eks_db_nodes_sg.name
# }

# output "frontend_sg" {
#   value = aws_security_group.eks_app_nodes_sg.id
# }

# output "frontend_sg_name" {
#   value = aws_security_group.eks_app_nodes_sg.name
# }

output "jumper_server_sg" {
  value = aws_security_group.bastion_sg.id
}


# output "lb_url" {
#   value = aws_lb.eks_lb.dns_name
# }

# output "cluster_nodes_sg" {
#   value = aws_security_group.cluster_nodes_sg.id
# }