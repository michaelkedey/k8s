locals {
  serverconfig = [
    for config in var.configurations : [
      for i in range(1, config.no_of_instances+1) : {
        instance_name = format("%s-%s", "${var.prefix}", "${config.name}-${i}")
        #"${config.name}-${i}"
        instance_type = config.instance_type
        subnet_id   = var.subnet_ids
        ami = data.aws_ami.latest_ubuntu.id
        security_groups = var.sgs
        tags = merge(
          var.tags_all,
          {
            Name = format("%s-%s", "${var.prefix}", "${config.name}-${i}")
          }
        )
      }
    ]
  ]
}

locals {
  instances = flatten(local.serverconfig)
}