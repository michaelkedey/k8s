variable "instance_count" {
  type        = number
  default     = 3
}

variable "instance_types" {
  type        = list(string)
  default     = ["t2.micro", "t2.small", "t2.medium"]
}

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

variable "subnet_ids" {
  type = string
}

variable "sgs" {
  type = list(string)
}

variable "enable" {
  default = true
  type    = bool
}

variable "key_name" {

}