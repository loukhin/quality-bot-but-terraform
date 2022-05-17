

variable "subnet_list" {
  type = list(string)
  description = "subnet to use in lb"
}

variable "security_group_list" {
  type = list(string)
  description = "security groups to use in lb"
}

variable "vpc_id" {
  type = string
  description = "vpc id "
}

variable "cName" {
  type = string
  description = "primary name"
}