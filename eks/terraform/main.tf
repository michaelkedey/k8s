#1 create cluster network 
module "cluster_network" {
  source          = "./modules/networking"
  # eks_node_group1 = module.cluster.node_group_one
  # eks_node_group2 = module.cluster.node_group_two 
}

#cluster
module "cluster" {
  source          = "./modules/cluster"
  vpc_id          = module.cluster_network.vpc_id
  private_subnets = [module.cluster_network.sn_private1_id, module.cluster_network.sn_private2_id]
  backend_sg      = module.cluster_network.backend_sg
  frontend_sg     = module.cluster_network.frontend_sg
}

