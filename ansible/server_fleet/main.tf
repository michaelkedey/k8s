module "vpc" {
  source       = "./modules/networking"
  instance_ids = module.server_fleet.fleet_ids
}

module "master" {
  source    = "./modules/master"
  key_name  = var.key_name
  subnet_id = module.vpc.sn_public1_id
  sg        = [module.vpc.control_sg]
}

module "server_fleet" {
  source         = "./modules/servers"
  key_name       = var.key_name
  sgs            = [module.vpc.slaves_sg]
  subnet_ids     = module.vpc.sn_private1_id
  configurations = var.configurations
}