
variable "sg_list" {
  type = list(string)
  description = "list of security groups"
}

variable "subnet_list" {
  type = list(string)
  description = "subnet use in lb"
}

variable "vpc_id" {
  type = string
  description = "vpc id "
}

variable "cName" {
  type = string
  description = "primary name"
}