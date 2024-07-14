data "aws_secretsmanager_secret" "key_pair" {
  name = "dev/key"
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

  key_name = data.aws_secretsmanager_secret.key_pair.name

  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.name}")
    }
  )
}
