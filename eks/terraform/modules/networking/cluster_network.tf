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

resource "aws_subnet" "sn_private3" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = local.subnets["prvt_sn3"]
  provider          = aws.eks_region
  availability_zone = local.azs[2]
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["prvt_sn3"]}")
    }
  )
}

#public subnets
resource "aws_subnet" "sn_public1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = local.subnets["pblc_sn1"]
  provider          = aws.eks_region
  availability_zone = local.azs[0]
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
  availability_zone = local.azs[1]
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["pblc_sn2"]}")
    }
  )
}

resource "aws_subnet" "sn_public3" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = local.subnets["pblc_sn3"]
  provider          = aws.eks_region
  availability_zone = local.azs[2]
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["pblc_sn3"]}")
    }
  )
}

#Internet_gateway
resource "aws_internet_gateway" "eks_igw" {
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
    gateway_id = aws_internet_gateway.eks_igw.id
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

resource "aws_route_table_association" "pblc_rt_assoc3" {
  subnet_id      = aws_subnet.sn_public3.id
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
  depends_on = [aws_internet_gateway.eks_igw]
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

#associate private rt with private sn2
resource "aws_route_table_association" "private_association3" {
  subnet_id      = aws_subnet.sn_private3.id
  route_table_id = aws_route_table.eks_private_rt.id
}

# db sg
resource "aws_security_group" "eks_db_nodes_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  name   = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["db_sg"]}")
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["db_sg"]}")
    }
  )
}

#app sg
resource "aws_security_group" "eks_app_nodes_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  name   = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["app_sg"]}")
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["app_sg"]}")
    }
  )
}

resource "aws_security_group" "cluster_nodes_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  name   = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["cluster_nodes"]}")
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["cluster_nodes"]}")
    }
  )
}


resource "aws_security_group_rule" "eks_db_nodes_sg_ingress1" {
  type              = "ingress"
  security_group_id = aws_security_group.eks_db_nodes_sg.id
  from_port         = local.rt_rules.rule_7.port
  to_port           = local.rt_rules.rule_7.port
  protocol          = local.rt_rules.rule_7.protocol
  #self                     = var.disable
  source_security_group_id = aws_security_group.eks_app_nodes_sg.id
  description              = "postgres"
  #cidr_blocks              = []
  # ipv6_cidr_blocks         = []
  prefix_list_ids = []

}

resource "aws_security_group_rule" "eks_db_nodes_sg_ingress2" {
  type              = "ingress"
  security_group_id = aws_security_group.eks_db_nodes_sg.id
  from_port         = local.rt_rules.rule_8.port
  to_port           = local.rt_rules.rule_8.port
  protocol          = local.rt_rules.rule_8.protocol
  #self                     = var.disable
  source_security_group_id = aws_security_group.eks_app_nodes_sg.id
  description              = "redis"
  #cidr_blocks              = []
  # ipv6_cidr_blocks         = []
  prefix_list_ids = []

}

resource "aws_security_group_rule" "eks_db_nodes_sg_ingress3" {
  type              = "ingress"
  security_group_id = aws_security_group.eks_db_nodes_sg.id
  from_port         = local.rt_rules.rule_9.port
  to_port           = local.rt_rules.rule_9.port
  protocol          = local.rt_rules.rule_9.protocol
  #self                     = var.disable
  source_security_group_id = aws_security_group.bastion_sg.id
  description              = "ssh"
  #cidr_blocks              = []
  # ipv6_cidr_blocks         = []
  prefix_list_ids = []

}

resource "aws_security_group_rule" "eks_db_nodes_sg_egress" {
  type              = "egress"
  security_group_id = aws_security_group.eks_db_nodes_sg.id
  from_port         = local.rt_rules.rule_3.port
  to_port           = local.rt_rules.rule_3.port
  protocol          = local.rt_rules.rule_3.protocol
  cidr_blocks       = local.def_egress_cidr

}

resource "aws_security_group_rule" "eks_app_nodes_sg_ingress1" {
  type              = "ingress"
  security_group_id = aws_security_group.eks_app_nodes_sg.id
  from_port         = local.rt_rules.rule_2.port
  to_port           = local.rt_rules.rule_2.port
  protocol          = local.rt_rules.rule_2.protocol
  #self              = var.disable
  #source_security_group_id = aws_security_group.eks_db_nodes_sg.id
  description = "apps"
  cidr_blocks = local.def_egress_cidr
  #ipv6_cidr_blocks = []
  prefix_list_ids = []

}

resource "aws_security_group_rule" "eks_app_nodes_sg_ingress2" {
  type              = "ingress"
  security_group_id = aws_security_group.eks_app_nodes_sg.id
  from_port         = local.rt_rules.rule_9.port
  to_port           = local.rt_rules.rule_9.port
  protocol          = local.rt_rules.rule_9.protocol
  #self                     = var.disable
  source_security_group_id = aws_security_group.bastion_sg.id
  description              = "ssh"
  #cidr_blocks              = []
  # ipv6_cidr_blocks         = []
  prefix_list_ids = []

}

resource "aws_security_group_rule" "eks_app_nodes_sg_egress" {
  type              = "egress"
  security_group_id = aws_security_group.eks_app_nodes_sg.id
  from_port         = local.rt_rules.rule_3.port
  to_port           = local.rt_rules.rule_3.port
  protocol          = local.rt_rules.rule_3.protocol
  cidr_blocks       = local.def_egress_cidr

}

resource "aws_security_group_rule" "eks_nodes_sg_ingress1" {
  type              = "ingress"
  security_group_id = aws_security_group.cluster_nodes_sg.id
  from_port         = local.rt_rules.rule_10.port
  to_port           = local.rt_rules.rule_10.port
  protocol          = local.rt_rules.rule_10.protocol
  self              = var.enable
  #source_security_group_id = aws_security_group.eks_app_nodes_sg.id
  #description              = "postgres"
  #cidr_blocks              = []
  # ipv6_cidr_blocks         = []
  prefix_list_ids = []
}

resource "aws_security_group_rule" "eks_nodes_sg_ingress2" {
  type              = "ingress"
  security_group_id = aws_security_group.cluster_nodes_sg.id
  from_port         = local.rt_rules.rule_11.port
  to_port           = local.rt_rules.rule_11.port
  protocol          = local.rt_rules.rule_11.protocol
  self              = var.enable
  #source_security_group_id = var.cluster_sg_id
  #description              = "postgres"
  #cidr_blocks              = []
  # ipv6_cidr_blocks         = []
  prefix_list_ids = []
}

resource "aws_security_group_rule" "eks_nodes_sg_ingress3" {
  type              = "ingress"
  security_group_id = aws_security_group.cluster_nodes_sg.id
  from_port         = local.rt_rules.rule_12.port
  to_port           = local.rt_rules.rule_12.port
  protocol          = local.rt_rules.rule_12.protocol
  #self                     = var.disable
  source_security_group_id = var.cluster_sg_id
  #description              = "postgres"
  #cidr_blocks              = []
  # ipv6_cidr_blocks         = []
  prefix_list_ids = []
}

resource "aws_security_group_rule" "eks_nodes_sg_ingress4" {
  type              = "ingress"
  security_group_id = aws_security_group.cluster_nodes_sg.id
  from_port         = local.rt_rules.rule_13.port
  to_port           = local.rt_rules.rule_13.port
  protocol          = local.rt_rules.rule_13.protocol
  #self                     = var.disable
  source_security_group_id = var.cluster_sg_id
  #description              = "postgres"
  #cidr_blocks              = []
  # ipv6_cidr_blocks         = []
  prefix_list_ids = []
}

resource "aws_security_group_rule" "eks_nodes_sg_ingress5" {
  type              = "ingress"
  security_group_id = aws_security_group.cluster_nodes_sg.id
  from_port         = local.rt_rules.rule_14.port
  to_port           = local.rt_rules.rule_14.port
  protocol          = local.rt_rules.rule_14.protocol
  #self                     = var.disable
  source_security_group_id = var.cluster_sg_id
  #description              = "postgres"
  #cidr_blocks              = []
  # ipv6_cidr_blocks         = []
  prefix_list_ids = []
}

resource "aws_security_group_rule" "eks_nodes_sg_ingress6" {
  type              = "ingress"
  security_group_id = aws_security_group.cluster_nodes_sg.id
  from_port         = local.rt_rules.rule_15.port
  to_port           = local.rt_rules.rule_15.port
  protocol          = local.rt_rules.rule_15.protocol
  #self                     = var.disable
  source_security_group_id = var.cluster_sg_id
  #description              = "postgres"
  #cidr_blocks              = []
  # ipv6_cidr_blocks         = []
  prefix_list_ids = []
}

resource "aws_security_group_rule" "eks_nodes_sg_ingress7" {
  type              = "ingress"
  security_group_id = aws_security_group.cluster_nodes_sg.id
  from_port         = local.rt_rules.rule_16.port
  to_port           = local.rt_rules.rule_16.port
  protocol          = local.rt_rules.rule_16.protocol
  #self                     = var.disable
  source_security_group_id = var.cluster_sg_id
  #description              = "postgres"
  #cidr_blocks              = []
  # ipv6_cidr_blocks         = []
  prefix_list_ids = []
}

resource "aws_security_group_rule" "eks_nodes_sg_ingress8" {
  type              = "ingress"
  security_group_id = aws_security_group.cluster_nodes_sg.id
  from_port         = local.rt_rules.rule_17.port
  to_port           = local.rt_rules.rule_17.port
  protocol          = local.rt_rules.rule_17.protocol
  #self                     = var.disable
  source_security_group_id = var.cluster_sg_id
  #description              = "postgres"
  #cidr_blocks              = []
  # ipv6_cidr_blocks         = []
  prefix_list_ids = []
}

resource "aws_security_group_rule" "eks_nodes_sg_ingress9" {
  type              = "ingress"
  security_group_id = aws_security_group.cluster_nodes_sg.id
  from_port         = local.rt_rules.rule_18.fromport
  to_port           = local.rt_rules.rule_18.toport
  protocol          = local.rt_rules.rule_18.protocol
  self              = var.enable
  #source_security_group_id = var.cluster_sg_id
  #description              = "postgres"
  #cidr_blocks              = []
  # ipv6_cidr_blocks         = []
  prefix_list_ids = []
}

resource "aws_security_group_rule" "eks_nodes_sg_egress" {
  type              = "egress"
  security_group_id = aws_security_group.cluster_nodes_sg.id
  from_port         = local.rt_rules.rule_3.port
  to_port           = local.rt_rules.rule_3.port
  protocol          = local.rt_rules.rule_3.protocol
  cidr_blocks       = local.def_egress_cidr

}

#bastion_sg
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  name   = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["bastion_sg"]}")

  ingress {
    from_port   = local.rt_rules.rule_9.port
    to_port     = local.rt_rules.rule_9.port
    protocol    = local.rt_rules.rule_9.protocol
    cidr_blocks = local.def_egress_cidr
    #security_groups = [aws_security_group.eks_app_nodes_sg.id, aws_security_group.eks_db_nodes_sg.id]
  }

  egress {
    from_port   = local.rt_rules.rule_3.port
    to_port     = local.rt_rules.rule_3.port
    protocol    = local.rt_rules.rule_3.protocol
    cidr_blocks = local.def_egress_cidr
  }

  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["bastion_sg"]}")
    }
  )
}

# #vpc_endpoint_sg
# resource "aws_security_group" "vpc_endpoint_sg" {
#   vpc_id = aws_vpc.eks_vpc.id

#   ingress {
#     from_port   = local.rt_rules.rule_1.port
#     to_port     = local.rt_rules.rule_1.port
#     protocol    = local.rt_rules.rule_1.protocol
#     cidr_blocks = [var.vpc_cidr]
#   }

#   egress {
#     from_port   = local.rt_rules.rule_1.port
#     to_port     = local.rt_rules.rule_1.port
#     protocol    = local.rt_rules.rule_1.protocol
#     cidr_blocks = ["]com.amazonaws.${eks_region}.ssm"]
#   }

#   tags = merge(
#     var.tags_all,
#     {
#       Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["endpoint_sg"]}")
#     }
#   )
#}


#load balancer
resource "aws_lb" "eks_lb" {
  name               = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["lb"]}")
  internal           = var.disable
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.eks_app_nodes_sg.id]
  subnets            = [aws_subnet.sn_public1.id, aws_subnet.sn_public2.id, aws_subnet.sn_public3.id]
  #enable_deletion_protection = true

  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["lb"]}")
    }
  )
}


#load balancer traffic listener
resource "aws_lb_listener" "eks_lb_listener" {
  load_balancer_arn = aws_lb.eks_lb.arn
  port              = local.rt_rules.rule_2a.port
  protocol          = local.rt_rules.rule_2a.protocol

  default_action {
    type             = var.lb_default_action
    target_group_arn = aws_lb_target_group.eks_lb_target_group.arn
  }
  tags = var.tags_all
}

#target group for load balancer
resource "aws_lb_target_group" "eks_lb_target_group" {
  name     = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["lb-tg"]}")
  port     = local.rt_rules.rule_2a.port
  protocol = local.rt_rules.rule_2a.protocol
  vpc_id   = aws_vpc.eks_vpc.id
  #depends_on = [module.eks.aws_eks_node_group["two"]]
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["lb-tg"]}")
    }
  )
}


# Example resource to modify security group rules after provisioning
resource "aws_security_group_rule" "eks_node_group_one_ingress" {
  type                     = "ingress"
  security_group_id        = var.eks_cluster_sg
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  description              = "nodes to cluster_sg"
  source_security_group_id = aws_security_group.cluster_nodes_sg.id
}

# Create a new launch template resource with the desired changes
resource "aws_launch_template" "modified_one" {
  name          = var.launch_one_name
  vpc_security_group_ids = [aws_security_group.eks_app_nodes_sg.id]

  # Use the existing launch template's default version as the new version
  default_version = data.aws_launch_template.existing.default_version
}




# resource "aws_vpc_endpoint" "ssm_endpoint" {
#   vpc_id            = aws_vpc.eks_vpc.id
#   service_name      = "com.amazonaws.${eks_region}.ssm"
#   vpc_endpoint_type = var.vpc_endpoint_type 

#   security_group_ids = [aws_security_group.vpc_endpoint_sg]
#   subnet_ids         = [aws_subnet.sn_private1, aws_subnet.sn_private2, aws_subnet.sn_private3]
# }

#associate the node groups  with the target group
# resource "aws_lb_target_group_attachment" "node_group_one" {
#   target_group_arn = aws_lb_target_group.eks_lb_target_group.arn
#   #target_id        = aws_eks_node_group.one.resources[0].id
#   target_id = var.eks_node_group1
#   port      = local.rt_rules.rule_2.port
# }

# resource "aws_lb_target_group_attachment" "node_group_two" {
#   target_group_arn = aws_lb_target_group.eks_lb_target_group.arn
#   target_id        = var.eks_node_group2
#   port             = local.rt_rules.rule_2.port
# }