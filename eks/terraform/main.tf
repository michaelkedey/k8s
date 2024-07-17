#1 create cluster network 
module "cluster_network" {
  source         = "./modules/networking"
  node_sg        = module.cluster.node_group
  cluster_sg_id  = module.cluster.cluster_sg
  eks_cluster_sg = module.cluster.eks_cluster_sg
  launch_one_name = module.cluster.eks_node_group_launch_template_name_one
}

#bastion
module "jumper_server" {
  source      = "./modules/jumper_server"
  sg          = [module.cluster_network.jumper_server_sg]
  subnet_id   = module.cluster_network.sn_public2_id
  private_key = var.private_key
  key_name    = var.key_name
}

#cluster
module "cluster" {
  source           = "./modules/cluster"
  vpc_id           = module.cluster_network.vpc_id
  private_subnets  = [module.cluster_network.sn_private1_id, module.cluster_network.sn_private2_id]
  backend_sg       = module.cluster_network.backend_sg
  frontend_sg      = module.cluster_network.frontend_sg
  bastion_host_ip  = module.jumper_server.bastion_public_ip
  private_sn1      = module.cluster_network.sn_private1_id
  private_sn2      = module.cluster_network.sn_private2_id
  cluster_nodes_sg = module.cluster_network.cluster_nodes_sg
}

