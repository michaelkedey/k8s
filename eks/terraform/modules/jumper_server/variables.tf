variable "tags_all" {
  default = {
    "Environment" = "production",
    "Owner"       = "michael_kedey"
  }
}

variable "prefix" {
  default = "eks"
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