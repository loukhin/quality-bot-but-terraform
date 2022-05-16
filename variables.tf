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
  default     = "us-east-1"
}

// ตัวแปรในส่วนของ VPC
variable "network_address_space" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  type        = number
  description = "number of subnets to create"
  default     = 2
}

variable "pName" {
  type        = string
  description = "Common name for tagging and naming"
  default     = "Quality_Bot"
}

variable "amonut_music_instance" {
  type        = list(number)
  description = "value"
  default     = [2, 2, 6]
}


variable "music_group_size" {
  type        = list(number)
  description = "value"
  default     = [2, 2, 6]
}

variable "text_group_size" {
  type        = list(number)
  description = "value"
  default     = [1, 1, 1]
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
variable "text_instance_count" {
  type        = number
  description = "Text Instance count"
  default     = 2
}

variable "text_asg_count" {
  type        = number
  description = "number of text asg groups"
  default     = 2
}

variable "discord_client_id" {
  type        = string
  description = "Discord bot client id"
}
variable "discord_bot_token" {
  type        = string
  description = "Discord bot token"
  sensitive   = true
}
variable "youtube_api_key" {
  type        = string
  description = "Youtube api key"
  sensitive   = true
}
variable "lambda_layer_name" {
  type        = list(string)
  description = "Lambda layer name list"
  default     = ["ffmpeg", "ffprobe"]
}
variable "lambda_layer_count" {
  type        = number
  description = "Lambda layer count"
  default     = 2
}
