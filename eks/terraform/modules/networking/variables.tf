#vpc cidr
variable "vpc_cidr" {
  default = "177.70.0.0/24"
  type    = string
}

#resource name prefix
variable "prefix" {
  default = "eks"
  type    = string
}

# VPC names
variable "vpc_resource_names" {
  default = {
    vpc           = "vpc"
    prvt_sn1      = "private_sn1",
    prvt_sn2      = "private_sn2",
    prvt_sn3      = "private_sn3",
    pblc_sn1      = "public_sn1",
    pblc_sn2      = "public_sn2",
    pblc_sn3      = "public_sn3",
    igw           = "igw",
    ngw           = "ngw",
    pblc_rt       = "public_rt",
    prvt_rt       = "private_rt",
    lb            = "lb",
    lb-tg         = "lb-tg-http",
    cluster_sg    = "cluster_sg",
    db_sg         = "db_nodes_sg",
    app_sg        = "app_nodes_sg"
    lb_sg         = "lb_sg",
    eip           = "eip",
    lb            = "lb",
    tg            = "tg",
    bastion_sg    = "bastion_sg",
    endpoint_sg   = "vpc_endpoint_sg",
    cluster_nodes = "my_cluster_nodes_sg"
  }
}


variable "tags_all" {
  default = {
    "Environment" = "production",
    "Owner"       = "michael_kedey"
  }
}

variable "enable" {
  default = true
  type    = bool
}

variable "disable" {
  default = false
  type    = bool
}

variable "load_balancer_type" {
  default = "application"
}

variable "lb_default_action" {
  default = "forward"
}

variable "vpc_endpoint_type" {
  default = "Interface"
}

variable "node_sg" {

}

variable "cluster_sg_id" {

}

variable "eks_cluster_sg" {

}

variable "launch_one_name" {
  
}

# variable "eks_node_group1" {

# }

# variable "eks_node_group2" {

# }