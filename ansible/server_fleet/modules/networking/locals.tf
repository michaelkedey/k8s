locals {
  # CIDR blocks
  cidrs = {
    default_rt = "0.0.0.0/0"
  }

  subnets = {
    prvt_sn1 = cidrsubnet(var.vpc_cidr, 3, 1),
    prvt_sn2 = cidrsubnet(var.vpc_cidr, 3, 2),
    prvt_sn3 = cidrsubnet(var.vpc_cidr, 3, 3),
    pblc_sn1 = cidrsubnet(var.vpc_cidr, 3, 4),
    pblc_sn2 = cidrsubnet(var.vpc_cidr, 3, 5),
    pblc_sn3 = cidrsubnet(var.vpc_cidr, 3, 0)
  }

  # AZs
  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # Ingress rules
  rt_rules = {
    rule_1  = { port = 443, protocol = "tcp" },
    rule_2  = { port = 80, protocol = "tcp" },
    rule_2a = { port = 80, protocol = "HTTP" },
    rule_3  = { port = 0, protocol = -1 },
    rule_4  = { port = 2379, protocol = "tcp" }, #etcd,
    rule_5  = { fromport = 0, toport = 65535, protocol = "tcp" },
    rule_6  = { port = 10250, protocol = "tcp" }, #kubelet
    rule_7  = { port = 5432, protocol = "tcp" },  #postgress
    rule_8  = { port = 6378, protocol = "tcp" },  #redis
    rule_9  = { port = 22, protocol = "tcp" },    #ssh
    rule_10 = { port = 53, protocol = "tcp" },
    rule_11 = { port = 53, protocol = "udp" },
    rule_12 = { port = 10250, protocol = "tcp" },
    rule_13 = { port = 6443, protocol = "tcp" },
    rule_14 = { port = 4443, protocol = "tcp" },
    rule_15 = { port = 9443, protocol = "tcp" },
    rule_16 = { port = 8443, protocol = "tcp" },
    rule_17 = { port = 443, protocol = "tcp" },
    rule_18 = { fromport = 1025, toport = 65535, protocol = "tcp" },
    rule_19 = { port = 15990, protocol = "tcp" }
  }

  # Default egress CIDR
  def_egress_cidr      = ["0.0.0.0/0"]
  def_ipv6_egress_cidr = ["::/0"]

}
