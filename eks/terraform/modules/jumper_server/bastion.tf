# Create IAM role for bastion host
resource "aws_iam_role" "bastion_host_role" {
  name        = "bastion_host_role"
  description = "Role for bastion host"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

# Create IAM policy for bastion host
resource "aws_iam_policy" "bastion_host_policy" {
  name        = "bastion_host_policy"
  description = "Policy for bastion host"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus",
          "ssm:StartSession",
          "ssm:TerminateSession"
        ]
        Resource = "*"
        Effect   = "Allow"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "bastion_host_attach" {
  role       = aws_iam_role.bastion_host_role.name
  policy_arn = aws_iam_policy.bastion_host_policy.arn
}

# Create instance profile for bastion host
resource "aws_iam_instance_profile" "bastion_host_profile" {
  name = "bastion_host_profile"
  role = aws_iam_role.bastion_host_role.name
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

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.latest_ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  security_groups             = var.sg
  associate_public_ip_address = var.enable
  iam_instance_profile        = aws_iam_instance_profile.bastion_host_profile.name
  key_name                    = var.key_name #change to your key name

  # provisioner "remote-exec" {
  #   connection {
  #     type        = "ssh"
  #     host        = self.public_ip
  #     user        = "ubuntu"
  #     private_key = file(var.private_key)
  #   }

  #   inline = [
  #     "sudo yum install -y amazon-ssm-agent",
  #     "sudo systemctl enable amazon-ssm-agent",
  #     "sudo systemctl start amazon-ssm-agent"
  #   ]
  # }

  user_data = base64encode(<<EOF
    #!/bin/bash
    sudo yum install -y amazon-ssm-agent
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
    EOF
  )

  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.name}")
    }
  )
}
