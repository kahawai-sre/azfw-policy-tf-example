
variable "name" {
}

variable "resource_group_name" {
}

variable "location" {
}

variable "security_rules" {
    type = any
    default = null
}

variable "tags" {
  type = map(string)
  default = null
}
