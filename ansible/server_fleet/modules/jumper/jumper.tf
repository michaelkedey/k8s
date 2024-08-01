resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.latest_ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  security_groups             = var.sg
  associate_public_ip_address = var.enable
  iam_instance_profile        = aws_iam_instance_profile.bastion_host_profile.name
  key_name                    = var.key_name #change to your key name
  user_data            = <<-EOF
    #!/bin/bash
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install -y amazon-ssm-agent
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
    sudo apt-get install awscli -y
    sudo apt-get install -y software-properties-common
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt-get install -y ansible
  EOF

  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.name}")
    }
  )
}
