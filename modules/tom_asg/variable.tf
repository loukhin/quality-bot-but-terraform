variable "launch_configuration" {
    type = map(string)
    description = "launch configuration data"
}

variable "subnet_list" {
  type = list(string)
  description = "A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with"
}

variable "max" {
  type = number
  description = "The maximum size of the Auto Scaling Group."
}

variable "min" {
  type = number
  description = "The minimum size of the Auto Scaling Group. (See also Waiting for Capacity below.)"
}
variable "desired" {
  type = number
  description = "The number of Amazon EC2 instances that should be running in the group"
}

variable "health_check" {
  type = number
  description = "Time (in seconds) after instance comes into service before checking health."
  default = 300
}

variable "health_check_type" {
  type = string
  description = " \"EC2\" or \"ELB\". Controls how health checking is done."
  default = "ELB"
}

variable "force_delete" {
  type = bool
  description = "Allows deleting the Auto Scaling Group without waiting for all instances in the pool to terminate. You can force an Auto Scaling Group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling."
  default = true
}

variable "pName" {
  type = string
  description = "name of resouce"
}

