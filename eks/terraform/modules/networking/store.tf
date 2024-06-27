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

