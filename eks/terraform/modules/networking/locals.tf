locals {
  # CIDR blocks
  cidrs = {
    default_rt = "0.0.0.0/0"
  }

  subnets = {
    prvt_sn1 = cidrsubnet(var.vpc_cidr, 2, 1),
    prvt_sn2 = cidrsubnet(var.vpc_cidr, 2, 2),
    pblc_sn1 = cidrsubnet(var.vpc_cidr, 2, 3),
    pblc_sn2 = cidrsubnet(var.vpc_cidr, 2, 0)
  }

  # AZs
  azs = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]

  # Ingress rules
  rt_rules = {
    rule_1 = {
      port     = 443,
      protocol = "tcp"
    },
    rule_2 = {
      port     = 80,
      protocol = "tcp"
    },
    rule_3 = {
      port     = 0,
      protocol = -1
    },
    rule_4 = {
      port     = 2379,
      protocol = "tcp" #etcd acces
    },
    rule_5 = {
      fromport = 0,
      toport   = 65535
      protocol = "tcp"
    },
    rule_6 = {
      port     = 10250,
      protocol = "tcp" #kublet
    },
    rule_7 = {
      port     = 5432,
      protocol = "tcp" #postgres
    },
    rule_8 = {
      port     = 6378,
      protocol = "tcp" #redis
    }
  }

  # Default egress CIDR
  def_egress_cidr      = ["0.0.0.0/0"]
  def_ipv6_egress_cidr = ["::/0"]

}
