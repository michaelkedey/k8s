# module "irsa-ebs-csi" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "5.3.1"

#   # Module variables
#   role_name = "irsa-ebs-csi"
#   #attach_eks_cluster_policy = true
#   # attach_eks_node_policy    = true
#   attach_ebs_csi_policy = true
#   oidc_providers        = ["https://oidc.eks.${var.region}.amazonaws.com/id/${module.eks.cluster_id}"]
#   #service_accounts          = ["ebs-csi-controller-sa"]
# }

#iam roles for badtion access
data "aws_iam_policy_document" "ssm_policy" {
  statement {
    actions = [
      "ssm:DescribeInstanceInformation",
      "ssm:StartSession",
      "ssm:TerminateSession",
      "ssm:SendCommand",
      "ssm:GetCommandInvocation",
      "ssm:ListCommands",
      "ssm:ListCommandInvocations"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ssm_policy" {
  name        = format("%s-%s", "${var.prefix}", "${var.policy_name}")
  description = "Policy for granting SSM permissions"
  policy      = data.aws_iam_policy_document.ssm_policy.json
}

# Create IAM role for SSM permissions
resource "aws_iam_role" "ssm_role" {
  name = "SSM-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(
    var.tags_all,
    {
      Name = "SSM Role"
    }
  )
}

# Attach IAM policy to the SSM role
resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}

# Create IAM instance profile and associate with the SSM role
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.ssm_role.name

  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.instance_profile_name}")
    }
  )
}


#ami
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  provider    = aws.eks_region
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical's AWS account ID

}

resource "aws_launch_template" "back_end_template" {
  vpc_security_group_ids = [var.backend_sg]
  name                   = format("%s-%s", "${var.prefix}", "${var.backend_template}")
}

resource "aws_launch_template" "front_end_template" {
  vpc_security_group_ids = [var.frontend_sg]
  name                   = format("%s-%s", "${var.prefix}", "${var.frontend_template}")

}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = format("%s-%s", "${var.prefix}", "${var.eks_resource_names["cluster"]}")
  cluster_version = var.cluster_version

  cluster_endpoint_public_access           = var.enable
  enable_cluster_creator_admin_permissions = var.enable

  cluster_addons = {
    # aws-ebs-csi-driver = {
    #   service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    # }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name           = format("%s-%s", "${var.prefix}", "${var.eks_resource_names["backend"]}")
      ami            = data.aws_ami.latest_ubuntu.id
      instance_types = var.backend_instances
      #security_group_ids   = [var.backend_sg]
      subnet_ids           = [var.private_sn1]
      min_size             = var.backend_min
      max_size             = var.backend_max
      desired_size         = var.backend_desired
      iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
      launch_template = {
        name    = aws_launch_template.back_end_template.name
        #version = aws_launch_template.back_end_template.name.latest_version
      }
      user_data = <<-EOF
        #!/bin/bash
        yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
        systemctl start amazon-ssm-agent
        systemctl enable amazon-ssm-agent
      EOF
      tags = merge(
        var.tags_all,
        {
          Name = format("%s-%s", "${var.prefix}", "back_end")
        }
      )
    }

    two = {
      name           = format("%s-%s", "${var.prefix}", "${var.eks_resource_names["frontend"]}")
      ami            = data.aws_ami.latest_ubuntu.id
      instance_types = var.frontend_instances
      #security_group_ids   = [var.frontend_sg]
      subnet_ids           = [var.private_sn2]
      min_size             = var.frontend_min
      max_size             = var.frontend_max
      desired_size         = var.frontend_desired
      iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
      launch_template = {
        name    = aws_launch_template.front_end_template.name
        #version = aws_launch_template.front_end_template.name.latest_version
      }

      user_data = <<-EOF
        #!/bin/bash
        yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
        systemctl start amazon-ssm-agent
        systemctl enable amazon-ssm-agent
      EOF

      tags = merge(
        var.tags_all,
        {
          Name = format("%s-%s", "${var.prefix}", "front_end")
        }
      )
    }
  }
}

data "aws_eks_node_group" "one" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "one"
}

data "aws_eks_node_group" "two" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "two"
}

