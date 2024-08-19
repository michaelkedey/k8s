variable "instance_count" {
  type        = number
  default     = 5
}

variable "instance_types" {
  type        = list(string)
  default     = ["t2.micro","t2.medium"]
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

variable "key_name" {

}

variable "configurations" {
  description = "The total configuration, List of Objects/Dictionary"
  type = list(object({
    name            = string
    no_of_instances = number
    instance_type   = string
  }))
}


