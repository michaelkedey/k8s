variable "prefix" {
  default = "eks"
  type    = string
}

variable "eks_version" {
  default = "20.8.5"
  type    = string
}

variable "cluster_version" {
  default = "1.29"
  type    = string
}

variable "eks_resource_names" {
  default = {
    cluster  = "cluster",
    frontend = "frontend_nodes",
    backend  = "backend_nodes"
  }
}

variable "enable" {
  default = true
  type    = bool
}

variable "disable" {
  default = false
  type    = bool
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "backend_min" {
  default = 1
  type    = number
}

variable "backend_max" {
  default = 3
  type    = number
}

variable "backend_desired" {
  default = 2
  type    = number
}

variable "frontend_min" {
  default = 1
  type    = number
}

variable "frontend_max" {
  default = 3
  type    = number
}

variable "frontend_desired" {
  default = 2
  type    = number
}

variable "backend_instances" {
  default = ["t3.small"]
  type    = list(string)
}

variable "frontend_instances" {
  default = ["t3.small"]
  type    = list(string)
}

variable "backend_sg" {

}

variable "frontend_sg" {

}
