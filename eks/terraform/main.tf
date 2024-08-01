#1 create cluster network 
module "cluster_network" {
  source      = "./modules/networking"
  nodes_sg_id = module.cluster.node_groups_sg
}

#bastion
module "jumper_server" {
  source      = "./modules/jumper_server"
  sg          = [module.cluster_network.jumper_server_sg]
  subnet_id   = module.cluster_network.sn_public2_id
  key_name    = var.key_name
}

#cluster
module "cluster" {
  source          = "./modules/cluster"
  vpc_id          = module.cluster_network.vpc_id
  private_subnets = [module.cluster_network.sn_private1_id, module.cluster_network.sn_private2_id]
  private_sn1     = module.cluster_network.sn_private1_id
  private_sn2     = module.cluster_network.sn_private2_id
}

