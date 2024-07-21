variable "bucket_name" {
  type    = string
  default = "myoneansonlyhelmrepobucket"

}

variable "prefix" {
  type    = string
  default = "helm"
}

variable "tags_all" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  sensitive   = true
  default = {
    "Environment" = "development",
    "Owner"       = "michaelkedey"
  }
}

variable "version_status" {
  default = "Enabled"
  type    = string
}

variable "enable" {
  default = true
  type    = bool
}

variable "file_path" {
  default = "../../uploads"
}

variable "suffix" {
  default = "index.yaml"
  type    = string
}

variable "acl" {
  default = "private"
  type    = string
}

variable "cloudtrail_name" {
  default = "helm-repo-cloudtrail"
  type    = string
}

variable "logs_bucket" {
  type = string
}

variable "logs_prefix" {
  default = "helm-repo-logs/"
  type    = string
}