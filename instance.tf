##################################################################################
# DATA
##################################################################################

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

##################################################################################
# RESOURCES
##################################################################################

resource "aws_launch_configuration" "voice_conf" {
  name          = "voice_conf"
  image_id      = data.aws_ami.aws-linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = <<-EOT
  #!/bin/bash

  mkdir /opt/qualitybot
  cat > /opt/qualitybot/.env << EOF
  NODE_ENV=development
  PORT=80

  DISCORD_CLIENT_ID=${var.discord_client_id}
  DISCORD_BOT_TOKEN=${var.discord_bot_token}

  DATABASE_URL=postgresql://db_username:db_password@RDS_ENDPOINT_URL:5432/quality-bot
  # ^ อันนี้ต้องรอ RDS

  YOUTUBE_API_KEY=${var.youtube_api_key}

  # text | voice
  INSTANCE_TYPE=voice
  EOF

  sudo yum install -y docker
  sudo service docker start
  sudo usermod -a -G docker ec2-user
  sudo chkconfig docker on
  sudo docker pull ghcr.io/loukhin/quality-bot:latest
  sudo docker run -d --name quality-bot -p 80:80 --env-file /opt/qualitybot/.env ghcr.io/loukhin/quality-bot
  EOT
}

resource "aws_launch_configuration" "manager_conf" {
  count = var.text_instance_count

  name          = "text_conf_${count.index+1}"
  image_id      = data.aws_ami.aws-linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = <<-EOT
  #!/bin/bash

  mkdir /opt/qualitybot
  cat > /opt/qualitybot/.env << EOF
  NODE_ENV=development
  PORT=3000

  ELB_URL=http://localhost:3000
  CONVERTER_FUNCTION_NAME=qb-converter
  # ^ อันนี้ต้องรอ Lambda
  AWS_REGION=${var.region}

  AWS_ACCESS_KEY=${var.aws_access_key}
  AWS_SECRET_KEY=${var.aws_secret_key}

  DISCORD_CLIENT_ID=${var.discord_client_id}
  DISCORD_BOT_TOKEN=${var.discord_bot_token}

  YOUTUBE_API_KEY=${var.youtube_api_key}

  SLASH_COMMAND_TEST_GUILD_LIST=834492419000500224, 713658288855842816, 901459733834252308, 610863827390824448
  SHARD_COUNT=${var.text_instance_count}
  SHARD_ID=${count.index}

  DATABASE_URL=postgresql://db_username:db_password@RDS_ENDPOINT_URL:5432/quality-bot
  # ^ อันนี้ต้องรอ RDS

  # text | voice
  INSTANCE_TYPE=text
  EOF

  sudo yum install -y docker
  sudo service docker start
  sudo usermod -a -G docker ec2-user
  sudo chkconfig docker on
  sudo docker pull ghcr.io/loukhin/quality-bot:latest
  sudo docker run -d --name quality-bot --env-file /opt/qualitybot/.env ghcr.io/loukhin/quality-bot
  EOT
}

###############
# FOR TESTING #
###############

# resource "aws_instance" "voice_conf" {
#   ami      = data.aws_ami.aws-linux.id
#   instance_type = var.instance_type
#   key_name      = var.key_name
#   vpc_security_group_ids = [aws_security_group.Quality-SG.id]
#   subnet_id = module.vpc.subnet_list[0].id

#   user_data = <<-EOT
#   #!/bin/bash

#   mkdir /opt/qualitybot
#   echo "Tk9ERV9FTlY9cHJvZHVjdGlvbgpQT1JUPTgwCgpESVNDT1JEX0NMSUVOVF9JRD05MDY3NjQyOTE0NzcyMDkyMTgKRElTQ09SRF9CT1RfVE9LRU49T1RBMk56WTBNamt4TkRjM01qQTVNakU0LllZZFlEUS5tTWIzYXVEYkM2WDZWMEoxZTl2MktLQ25RaUEKCllPVVRVQkVfQVBJX0tFWT1BSXphU3lDQ2dYNVRqWlV3RzdaLUNrWER1MzdLMmw3Yjk4T3lMS3cKCiMgdGV4dCB8IHZvaWNlCklOU1RBTkNFX1RZUEU9dm9pY2UK" | base64 -d > /opt/qualitybot/.env
#   # echo "DATABASE_URL=postgresql://db_username:db_password@$RDS_ENDPOINT_URL:5432/quality-bot" >> /opt/qualitybot/.env
#   # ^ อันนี้ต้องรอ RDS

#   sudo yum install -y docker
#   sudo service docker start
#   sudo usermod -a -G docker ec2-user
#   sudo chkconfig docker on
#   sudo docker pull ghcr.io/loukhin/quality-bot:latest
#   sudo docker run -d --name quality-bot -p 80:80 --env-file /opt/qualitybot/.env ghcr.io/loukhin/quality-bot
#   EOT
# }

# resource "aws_instance" "text_conf" {
#   count = var.text_instance_count

#   ami      = data.aws_ami.aws-linux.id
#   instance_type = var.instance_type
#   key_name      = var.key_name
#   vpc_security_group_ids = [aws_security_group.Quality-SG.id]
#   subnet_id = module.vpc.subnet_list[count.index].id

#   user_data = <<-EOT
#   #!/bin/bash

#   mkdir /opt/qualitybot
#   cat > /opt/qualitybot/.env << EOF
#   NODE_ENV=development
#   PORT=3000

#   ELB_URL=http://localhost:3000
#   CONVERTER_FUNCTION_NAME=qb-converter
#   AWS_REGION=${var.region}

#   AWS_ACCESS_KEY=${var.aws_access_key}
#   AWS_SECRET_KEY=${var.aws_secret_key}

#   DISCORD_CLIENT_ID=${var.discord_client_id}
#   DISCORD_BOT_TOKEN=${var.discord_bot_token}

#   YOUTUBE_API_KEY=${var.youtube_api_key}

#   SLASH_COMMAND_TEST_GUILD_LIST=834492419000500224, 713658288855842816, 901459733834252308, 610863827390824448
#   SHARD_COUNT=${var.text_instance_count}
#   SHARD_ID=${count.index}

#   DATABASE_URL=postgresql://db_username:db_password@${data.aws_ami.aws-linux.id}:5432/quality-bot
#   # ^ อันนี้ต้องรอ RDS

#   # text | voice
#   INSTANCE_TYPE=text
#   EOF

#   sudo yum install -y docker
#   sudo service docker start
#   sudo usermod -a -G docker ec2-user
#   sudo chkconfig docker on
#   sudo docker pull ghcr.io/loukhin/quality-bot:latest
#   EOT

#   tags = {
#     "Name" = "text_conf_${count.index+1}"
#   }
# }
