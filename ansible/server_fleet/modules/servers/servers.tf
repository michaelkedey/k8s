# resource "aws_instance" "server_fleet" {
#   count = var.instance_count
#   key_name = var.key_name
#   ami           = data.aws_ami.latest_ubuntu.id
#   instance_type = var.instance_types[each.key]
#   subnet_id = var.subnet_ids
#   security_groups = var.sgs
#   tags = merge(
#   var.tags_all,
#   {
#     Name = format("%s-%s", "${var.prefix}", "${each.key + 1}")
#   }
# )
# }



resource "aws_instance" "server_fleet" {
  for_each = {for server in local.instances: server.instance_name =>  server}
  key_name = var.key_name
  ami           = each.value.ami
  instance_type = each.value.instance_type
  vpc_security_group_ids = each.value.security_groups
  subnet_id = each.value.subnet_id
  tags = {
    Name = "${each.value.instance_name}"
  }
}