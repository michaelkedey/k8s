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

