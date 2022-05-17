variable "pName" {
  type = string
  description = "Project Name using for tagging in the resource."
}

variable "subnet_id_list" {
  type = list(string)
  description = "Subnet id list for rds subnet group"
}

variable "securitygroup_id_list" {
  type = list(string)
  description = "Security group id list for rds"
}

variable "username" {
  type = string
  description = "Username for a database."
}

variable "password" {
  type = string
  description = "password for a database."

}
