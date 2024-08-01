module "vpc" {
  source = "./modules/networking"

}

module "jumper_server" {
  source = "./modules/jumper"
  key_name = var.key_name
  subnet_id = module.vpc.sn_public1_id
  sg = module.vpc.jumper_server_sg
}

module "server_fleet" {
    source = "./modules/servers"
    key_name = var.key_name
    sgs = module.vpc.servers_sg
    subnet_ids = module.vpc.sn_public1_id

}