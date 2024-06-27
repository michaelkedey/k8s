resource "aws_ssm_parameter" "vpc_id" {
  name  = format("/%s/%s", "${var.prefix}", "${var.vpc_resource_names["vpc"]}")
  type  = "String"
  value = aws_vpc.eks_vpc.id
  lifecycle {
    ignore_changes = [value]
  }

}

resource "aws_ssm_parameter" "sn_private1_id" {
  name  = format("/%s-%s", "${var.prefix}", "${var.vpc_resource_names["prvt_sn1"]}")
  type  = "String"
  value = aws_subnet.sn_private1.id
  lifecycle {
    ignore_changes = [value]
  }

}

resource "aws_ssm_parameter" "sn_private2_id" {
  name  = format("/%s-%s", "${var.prefix}", "${var.vpc_resource_names["prvt_sn2"]}")
  type  = "String"
  value = aws_subnet.sn_private2.id
  lifecycle {
    ignore_changes = [value]
  }

}

resource "aws_ssm_parameter" "sn_public1_id" {
  name  = format("/%s-%s", "${var.prefix}", "${var.vpc_resource_names["pblc_sn1"]}")
  type  = "String"
  value = aws_subnet.sn_public1.id
  lifecycle {
    ignore_changes = [value]
  }

}

resource "aws_ssm_parameter" "sn_public2_id" {
  name  = format("/%s-%s", "${var.prefix}", "${var.vpc_resource_names["pblc_sn2"]}")
  type  = "String"
  value = aws_subnet.sn_public2.id
  lifecycle {
    ignore_changes = [value]
  }

}

# # resource "aws_ssm_parameter" "beanstalk_subnets" {
# #   name = "/bid/beanstalk_subnets"
# #   value = [
# #     aws_subnet.sn_private1.id,
# #     aws_subnet.sn_private2.id
# #   ]
# #   type = "String"

# # }

# resource "aws_ssm_parameter" "vpc_sg_id" {
#   name  = "/bid/vpc_sg_id"
#   type  = "String"
#   value = aws_security_group.beanstalk_sg.id

# }

# resource "aws_ssm_parameter" "beanstalk_sn_lists" {
#   name  = "/bid/beanstalk_sn_lists"
#   type  = "String"
#   value = join(",", [aws_subnet.sn_private1.id, aws_subnet.sn_private2.id])

# }

# resource "aws_ssm_parameter" "lb_sn_lists" {
#   name  = "/bid/lb_sn_lists"
#   type  = "String"
#   value = join(",", [aws_subnet.sn_public1.id, aws_subnet.sn_public2.id])

# }