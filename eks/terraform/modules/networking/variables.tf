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
    vpc        = "vpc"
    prvt_sn1   = "private_sn1",
    prvt_sn2   = "private_sn2",
    pblc_sn1   = "public_sn1",
    pblc_sn2   = "public_sn2",
    igw        = "igw",
    ngw        = "ngw",
    pblc_rt    = "public_rt",
    prvt_rt    = "private_rt",
    lb         = "lb",
    lb-tg1     = "lb-tg-http",
    lb-tg2     = "lb-tg-https",
    cluster_sg = "cluster_sg",
    db_sg      = "db_nodes_sg",
    app_sg     = "app_nodes_sg"
    lb_sg      = "lb_sg",
    eip        = "eip"
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



















# #vpc cidrs
# variable "cidrs" {
#   default = {
#     vpc           = "177.70.0.0/24",
#     sn_private1   = "177.70.0.0/26",
#     sn_private2   = "177.70.0.64/26",
#     sn_public1    = "177.70.0.128/27",
#     sn_public2    = "177.70.0.192/27",
#     default_route = "0.0.0.0/0"
#   }

#   sensitive   = true
#   type        = map(string)
#   description = "cidr blocks for vpc components"
# }

# #names
# variable "vpc_names" {
#   default = {
#     vpc          = "bid_vpc",
#     sn_private1  = "bid_private_sn1",
#     sn_private2  = "bid_private_sn2",
#     sn_public1   = "bid_public_sn1",
#     sn_public2   = "bid_public_sn2",
#     igw          = "bid_igw",
#     ngw          = "bid_ngw",
#     public_rt    = "bid_public_rt",
#     private_rt   = "bid_private_rt",
#     beanstalk_sg = "bid-beanstalk-instances-sgs",
#     lb           = "bid-lb",
#     lb-tg1       = "bid-lb-tg-http",
#     lb-tg2       = "bid-lb-tg-https",
#     lb_sg        = "bid-lb_sg"

#   }

#   type        = map(string)
#   description = "vpc names"
# }


# #https in
# variable "ingress1" {
#   default = {
#     from_port = 443
#     to_port   = 443
#     protocol  = "tcp"

#   }
# }

# #http in
# variable "ingress2" {
#   default = {
#     from_port = 80
#     to_port   = 80
#     protocol  = "tcp"

#   }
# }

# variable "ingress3" {
#   default = {
#     from_port = 0
#     to_port   = 0
#     protocol  = -1

#   }
# }

# #http out
# variable "egress2" {
#   default = {
#     from_port = 80
#     to_port   = 80
#     protocol  = "tcp"
#   }
# }

# #https out
# variable "egress1" {
#   default = {
#     from_port = 443
#     to_port   = 443
#     protocol  = "tcp"
#   }

# }

# variable "egress3" {
#   default = {
#     from_port = 0
#     to_port   = 0
#     protocol  = -1
#   }

# }



# variable "def_egress_cidr" {
#   default     = ["0.0.0.0/0"]
#   description = "allow traffic from everywhere"
#   type        = list(string)
# }

# variable "def_rt_cidr" {
#   default = "0.0.0.0/0"
#   type    = string
# }

# variable "tags_all" {
#   type        = map(string)
#   description = "A map of tags to assign to the resources."
#   sensitive   = true
#   default = {
#     "Environment" = "production",
#     "Owners"      = "bid_project"
#   }
# }