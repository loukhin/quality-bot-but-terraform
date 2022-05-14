##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {
    type        = string
    description = "AWS Access Key"
    sensitive   = true
}
variable "aws_secret_key" {
    type        = string
    description = "AWS Secret Key"
    sensitive   = true
}
variable "aws_session_token" {
    type        = string
    description = "AWS Session Token"
    sensitive   = true
}

variable "region" {
    type        = string
    description = "value for default region"
     default = "us-east-1"
}

// ตัวแปรในส่วนของ VPC
variable "network_address_space" {
    type        = string
    description = "Base CIDR Block for VPC"
    default = "10.0.0.0/16"
}

variable "subnet_count"{
    type = number
    description = "number of subnets to create"
    default = 2
}

variable "pName" {
    type        = string
    description = "Common name for tagging and naming"
    default = "Quality_Bot"
}

variable "amonut_music_instance" {
  type = list(number)
  description = "value"
  default = [ 2,2,6 ]
}
variable "key_name" {
    type        = string
    description = "Private key name"
    sensitive   = false
}
variable "instance_type" {
  type        = string
  description = "Type for EC2 Instance"
  default     = "t2.micro"
}