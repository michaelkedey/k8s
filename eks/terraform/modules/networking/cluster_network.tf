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
      ipv6_cidr_blocks = local.def_ipv6_egress_cidr
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

  #depends_on = [aws_security_group.eks_app_nodes_sg]
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
      security_groups  = [aws_security_group.eks_db_nodes_sg.id]
      self             = var.disable
    }
  ]

  egress {
    from_port = local.rt_rules.rule_3.port
    to_port   = local.rt_rules.rule_3.port
    protocol  = local.rt_rules.rule_3.protocol
  }

  #depends_on = [aws_security_group.eks_db_nodes_sg]
}

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
  port              = local.rt_rules.rule_2.port
  protocol          = local.rt_rules.rule_2.protocol

  default_action {
    type             = var.lb_default_action
    target_group_arn = aws_lb_target_group.eks_lb_target_group.arn
  }
  tags = var.tags_all
}

#target group for load balancer
resource "aws_lb_target_group" "eks_lb_target_group" {
  name     = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["lb-tg"]}")
  port     = local.rt_rules.rule_2.port
  protocol = local.rt_rules.rule_2.protocol
  vpc_id   = aws_vpc.eks_vpc.id
  #depends_on = [module.eks.aws_eks_node_group["two"]]
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.vpc_resource_names["lb-tg"]}")
    }
  )
}

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