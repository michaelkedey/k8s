resource "aws_instance" "server_fleet" {
  for_each = toset(range(var.instance_count))
  key_name = var.key_name
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = var.instance_types[each.key]
  subnet_id = var.subnet_ids
  security_groups = var.sgs
  tags = merge(
  var.tags_all,
  {
    Name = format("%s-%s", "${var.prefix}", "${each.key + 1}")
  }
)
}