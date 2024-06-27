#VPC 
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  provider             = aws.eks_region
  enable_dns_hostnames = var.enable
  enable_dns_support   = var.enable
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["vpc"]}")
    }
  )
}

#private subnets
resource "aws_subnet" "sn_private1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = local.subnets["prvt_sn1"]
  provider          = aws.eks_region
  availability_zone = local.azs[0]
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["prvt_sn1"]}")
    }
  )
}

resource "aws_subnet" "sn_private2" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = local.subnets["prvt_sn2"]
  provider          = aws.eks_region
  availability_zone = local.azs[1]
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["prvt_sn2"]}")
    }
  )
}

#public subnets
resource "aws_subnet" "sn_public1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = local.subnets["pblc_sn1"]
  provider          = aws.eks_region
  availability_zone = local.azs[2]
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["pblc_sn1"]}")
    }
  )
}

resource "aws_subnet" "sn_public2" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = local.subnets["pblc_sn2"]
  provider          = aws.eks_region
  availability_zone = local.azs[3]
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["pblc_sn2"]}")
    }
  )
}

#Internet_gateway
resource "aws_internet_gateway" "eks_gw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["igw"]}")
    }
  )
}

#public_rt
resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_vpc.id
  # specifies gateway of last resort for public subnets
  route {
    cidr_block = local.cidrs["default_rt"]
    gateway_id = aws_internet_gateway.eks_gw.id
  }
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["pblc_rt"]}")
    }
  )
}

#associate public rt with public subnet1
resource "aws_route_table_association" "pblc_rt_assoc1" {
  subnet_id      = aws_subnet.sn_public1.id
  route_table_id = aws_route_table.eks_public_rt.id
}

#associate public rt with public subnet2
resource "aws_route_table_association" "pblc_rt_assoc2" {
  subnet_id      = aws_subnet.sn_public2.id
  route_table_id = aws_route_table.eks_public_rt.id
}

#eip needed to work with the nat gateway
resource "aws_eip" "eks_eip" {
  #instance = var.instance_id
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["eip"]}")
    }
  )
}

#nat gateway
resource "aws_nat_gateway" "eks_ngw" {
  allocation_id = aws_eip.eks_eip.id
  #nat gateway created in a public subnet
  subnet_id = aws_subnet.sn_public1.id
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["ngw"]}")
    }
  )
  depends_on = [aws_internet_gateway.eks_gw]
}


#private route table
resource "aws_route_table" "eks_private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    # specifies gateway of last resort for private subnets
    cidr_block     = local.cidrs["default_rt"]
    nat_gateway_id = aws_nat_gateway.eks_ngw.id
  }

  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["prvt_rt"]}")
    }
  )
}

#associate private rt with private sn1
resource "aws_route_table_association" "private_association1" {
  subnet_id      = aws_subnet.sn_private1.id
  route_table_id = aws_route_table.eks_private_rt.id
}

#associate private rt with private sn2
resource "aws_route_table_association" "private_association2" {
  subnet_id      = aws_subnet.sn_private2.id
  route_table_id = aws_route_table.eks_private_rt.id
}

# #security groups
# resource "aws_security_group" "eks_cluster_sg" {
#   vpc_id = aws_vpc.eks_vpc.id

#   name        = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["cluster_sg"]}")
#   description = "EKS Cluster security group"
#   tags = merge(
#     var.tags_all,
#     {
#       Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["cluster_sg"]}")
#     }
#   )

#   # Allow outbound traffic to the internet
#   egress {
#     from_port   = local.rt_rules.rule_3.port
#     to_port     = local.rt_rules.rule_3.port
#     protocol    = local.rt_rules.rule_3.protocol
#     cidr_blocks = local.def_egress_cidr
#   }

#   # Allow nodes to communicate with the cluster
#   ingress {
#     description = "Allow all node-to-node communication"
#     from_port   = local.rt_rules.rule_3.port
#     to_port     = local.rt_rules.rule_3.port
#     protocol    = local.rt_rules.rule_3.protocol
#     security_groups = [
#       aws_security_group.eks_node_sg.id,
#     ]
#   }

#   ingress {
#     from_port   = local.rt_rules.rule_5.fromport
#     to_port     = local.rt_rules.rule_5.toport
#     protocol    = local.rt_rules.rule_5.protocol
#     security_groups = [
#       aws_security_group.node_communication_sg.id
#     ]
#   }

#   #allow traffic from the etcd server
#   ingress {
#     from_port   = local.rt_rules.rule_4.port
#     to_port     = local.rt_rules.rule_4.port
#     protocol    = local.rt_rules.rule_4.protocol
#     cidr_blocks = [aws_vpc.eks_vpc.cidr_block]
#   }
# }


# db sg
resource "aws_security_group" "eks_db_nodes_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["db_sg"]}")
    }
  )

  ingress = [
    {
      from_port        = local.rt_rules.rule_7.port
      to_port          = local.rt_rules.rule_7.port
      protocol         = local.rt_rules.rule_7.protocol
      cidr_blocks      = local.def_egress_cidr
      description      = "postgres"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = var.disable
    },

    {
      from_port        = local.rt_rules.rule_8.port
      to_port          = local.rt_rules.rule_8.port
      protocol         = local.rt_rules.rule_8.protocol
      cidr_blocks      = local.def_egress_cidr
      description      = "redis"
      ipv6_cidr_blocks = local.def_ipv6_egress_cidr
      prefix_list_ids  = []
      security_groups  = []
      self             = var.disable
    }
  ]
  egress {
    from_port = local.rt_rules.rule_3.port
    to_port   = local.rt_rules.rule_3.port
    protocol  = local.rt_rules.rule_3.protocol
  }
}

#app sg
resource "aws_security_group" "eks_app_nodes_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["app_sg"]}")
    }
  )

  ingress = [
    {
      from_port        = local.rt_rules.rule_2.port
      to_port          = local.rt_rules.rule_2.port
      protocol         = local.rt_rules.rule_2.protocol
      cidr_blocks      = local.def_egress_cidr
      description      = "apps"
      ipv6_cidr_blocks = local.def_ipv6_egress_cidr
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port = local.rt_rules.rule_3.port
    to_port   = local.rt_rules.rule_3.port
    protocol  = local.rt_rules.rule_3.protocol
  }
}



# #sg for lambda instances
# resource "aws_security_group" "beanstalk_sg" {
#   name        = var.vpc_names["beanstalk_sg"]
#   description = "Sg for Beanstalk"
#   vpc_id      = aws_vpc.eks_vpc.id

#   ingress {
#     from_port   = var.ingress1["from_port"]
#     to_port     = var.ingress1["to_port"]
#     protocol    = var.ingress1["protocol"]
#     cidr_blocks = var.def_egress_cidr #[ aws_subnet.sn_private1.cidr_block, aws_subnet.sn_private2.cidr_block ] #security_groups = var.lb_sg
#   }

#   ingress {
#     from_port   = var.ingress2["from_port"]
#     to_port     = var.ingress2["to_port"]
#     protocol    = var.ingress2["protocol"]
#     cidr_blocks = var.def_egress_cidr #[ aws_subnet.sn_private1.cidr_block, aws_subnet.sn_private2.cidr_block ] #var.def_egress_cidr #security_groups = var.lb_sg
#   }

#   ingress {
#     from_port   = var.ingress3["from_port"]
#     to_port     = var.ingress3["to_port"]
#     protocol    = var.ingress3["protocol"]
#     cidr_blocks = var.def_egress_cidr #[ aws_subnet.sn_private1.cidr_block, aws_subnet.sn_private2.cidr_block ] 
#   }

#   egress {
#     from_port   = var.egress3["from_port"]
#     to_port     = var.egress3["to_port"]
#     protocol    = var.egress3["protocol"]
#     cidr_blocks = var.def_egress_cidr
#   }

#   egress {
#     from_port   = var.egress1["from_port"]
#     to_port     = var.egress1["to_port"]
#     protocol    = var.egress1["protocol"]
#     cidr_blocks = var.def_egress_cidr
#   }

#   egress {
#     from_port   = var.egress2["from_port"]
#     to_port     = var.egress2["to_port"]
#     protocol    = var.egress2["protocol"]
#     cidr_blocks = var.def_egress_cidr
#   }

#   egress {
#     from_port   = var.egress1["from_port"]
#     to_port     = var.egress1["to_port"]
#     protocol    = var.egress1["protocol"]
#     cidr_blocks = var.def_egress_cidr
#   }

#   tags = merge(
#     var.tags_all,
#     {
#       Name = var.vpc_names["beanstalk_sg"]
#     }
#   )

# }

