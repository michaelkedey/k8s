output "cluster_name" {
  #value = module.eks.cluster_name
  value = module.cluster.cluster_name
}

output "cluster_endpoint" {
  #value = module.eks.cluster_endpoint
  value = module.cluster.cluster_endpoint
}

output "cluster_ca_cert" {
  #value = aws_eks_cluster.this.certificate_authority[0].data
  #value = module.eks.cluster_certificate_authority_data
  value = module.cluster.cluster_ca_cert
}

output "lb_url" {
  value = module.cluster_network.lb_url
}

# output "bastion_ip" {
#   value = module.jumper_server.bastion_public_ip
# }