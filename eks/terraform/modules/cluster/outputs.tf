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

output "node_group" {
  value = module.eks.node_security_group_id
}

output "cluster_sg" {
  value = module.eks.cluster_security_group_id
}

output "eks_cluster_sg" {
  value = module.eks.cluster_primary_security_group_id
}

# output "eks_node_group_launch_template_id_one" {
#   value = data.aws_eks_node_group.one.launch_template.id
#   #value = module.eks.managed_node_group["one"].aws_eks_node_group.this[0].launch_template.id
# }

# output "eks_node_group_launch_template_name_one" {
#   value = data.aws_eks_node_group.one.launch_template.name
#   #value = module.eks.managed_node_group["one"].aws_eks_node_group.this[0].launch_template.name
# }

# output "eks_node_group_launch_template_id_two" {
#   value = data.aws_eks_node_group.two.launch_template.id
#   #value = module.eks.managed_node_group["two"].aws_eks_node_group.this[0].launch_template.id
# }

output "eks_node_group_launch_template_ids" {
  value = [for ng in data.aws_eks_node_group : ng.launch_template.id]
}
