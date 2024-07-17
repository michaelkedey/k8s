output "cluster_name" {
  #value = module.eks.cluster_name
  value = module.cluster.cluster_name
}

output "cluster_endpoint" {
  #value = module.eks.cluster_endpoint
  value = module.cluster.cluster_endpoint
}

# output "cluster_ca_cert" {
#   #value = aws_eks_cluster.this.certificate_authority[0].data
#   #value = module.eks.cluster_certificate_authority_data
#   value = module.cluster.cluster_ca_cert
# }

output "lb_url" {
  value = module.cluster_network.lb_url
}

output "bastion_ip" {
  value = module.jumper_server.bastion_public_ip
}

# # Output to display instance IDs
# output "managed_node_group_one_instance_ids" {
#   value = module.cluster.managed_node_group_one_instance_ids
# }

# output "managed_node_group_two_instance_ids" {
#   value = module.cluster.managed_node_group_two_instance_ids
# }