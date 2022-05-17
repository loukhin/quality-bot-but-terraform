variable "pName" {
  type = string
  description = "Project Name using for tagging in the resource."
}

variable "username" {
  type = string
  description = "Username for a database."
}

variable "password" {
  type = string
  description = "password for a database."
  
}

variable "subnet_group_name" {
  type = string
  description = "Subnet for Database."
}