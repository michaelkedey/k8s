variable "tags_all" {
  default = {
    "Environment" = "production",
    "Owner"       = "michael_kedey"
  }
}

variable "prefix" {
  default = "ansible"
  type    = string
}

variable "name" {
  default = "bastion_host"
  type    = string
}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "subnet_id" {
  type = string
}

variable "sg" {
  type = list(string)
}

variable "enable" {
  default = true
  type    = bool
}

variable "key_name" {

}

variable "ssm_host_profile"{
  default = "ssm_bastion_host_profile"
  type = string
}

variable "ssm_host_policy"{
  default = "ssm_bastion_host_policy"
  type = string
}

variable "ssm_host_role"{
  default = "ssm_bastion_host_role"
  type = string
}