variable "network_address_space" {
    type        = string
    description = "Base CIDR Block for VPC"
}


variable "pName" {
  type = string
  description = "Project Name using for tagging in the resource"
}

variable "subnet_count" {
  type = number
  description = "Number of Subnet to create"
}