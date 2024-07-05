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

# output "node_group_one" {
#   #value = module.eks.eks_managed_node_groups
#   value = data.aws_eks_node_group.node_group_one.instance_ids
# }

# output "node_group_two" {
#   #value = module.eks.eks_managed_node_groups
#   value = data.aws_eks_node_group.node_group_two.instance_ids

# }

# output "node_group_instance_ids_one" {
#   value = data.aws_autoscaling_group.node_group_one.instances[*].id
# }

# output "node_group_instance_ids_two" {
#   value = data.aws_autoscaling_group.node_group_two.instances[*].id
# }

# output "region" {
#   value = aws_region.this.name
# }