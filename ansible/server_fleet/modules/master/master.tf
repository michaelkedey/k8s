resource "aws_instance" "master" {
  ami                         = data.aws_ami.latest_ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  security_groups             = var.sg
  associate_public_ip_address = var.enable
  #iam_instance_profile        = aws_iam_instance_profile.bastion_host_profile.name
  key_name                    = var.key_name 
  user_data            = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-add-repository ppa:ansible/ansible -y
    sudo apt-get update -y
    sudo apt-get install ansible -y

  EOF

  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.name}")
    }
  )
}
