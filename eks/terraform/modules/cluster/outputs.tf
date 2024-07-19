# output "cluster_endpoint" {
#   value = module.eks.cluster_endpoint
# }

# output "cluster_security_group_id" {
#   value = module.eks.cluster_security_group_id
# }

# output "kubeconfig" {
#   value     = module.eks.kubeconfig
#   sensitive = true
# }

# output "config_map_aws_auth" {
#   value     = module.eks.config_map_aws_auth
#   sensitive = true
# }

# output "eks_cluster_id" {
#   value = module.eks.cluster_id
# }
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca_cert" {
  #value = aws_eks_cluster.this.certificate_authority[0].data
  value = module.eks.cluster_certificate_authority_data
}

output "node_groups_sg" {
  value = module.eks.node_security_group_id
}

output "node_ids" {
  value = module.eks.cluster_ip_family
}
