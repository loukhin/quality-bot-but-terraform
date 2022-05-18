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
  security_groups = [aws_security_group.quality-internal-web.id, aws_security_group.Quality-SG.id]

  user_data = <<-EOT
  #!/bin/bash

  mkdir /opt/qualitybot
  cat > /opt/qualitybot/.env << EOF
  NODE_ENV=development
  PORT=80

  DISCORD_CLIENT_ID=${var.discord_client_id}
  DISCORD_BOT_TOKEN=${var.discord_bot_token}

  DATABASE_URL=postgresql://${module.rds.Quality_RDS.username}:${module.rds.Quality_RDS.password}@${module.rds.Quality_RDS.endpoint}/${module.rds.Quality_RDS.db_name}

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
  security_groups = [aws_security_group.Quality-SG.id]

  user_data = <<-EOT
  #!/bin/bash

  mkdir /opt/qualitybot
  cat > /opt/qualitybot/.env << EOF
  NODE_ENV=development
  PORT=3000

  ELB_URL=http://${module.loadbalancer.reqLB.dns_name}
  CONVERTER_FUNCTION_NAME=${aws_lambda_function.qb-file-converter.function_name}
  AWS_REGION=${var.region}

  AWS_ACCESS_KEY=${var.aws_access_key}
  AWS_SECRET_KEY=${var.aws_secret_key}
  AWS_SESSION_TOKEN=${var.aws_session_token}

  DISCORD_CLIENT_ID=${var.discord_client_id}
  DISCORD_BOT_TOKEN=${var.discord_bot_token}

  YOUTUBE_API_KEY=${var.youtube_api_key}

  SLASH_COMMAND_TEST_GUILD_LIST=834492419000500224, 713658288855842816, 610863827390824448
  SHARD_COUNT=${var.text_instance_count}
  SHARD_ID=${count.index}

  DATABASE_URL=postgresql://${module.rds.Quality_RDS.username}:${module.rds.Quality_RDS.password}@${module.rds.Quality_RDS.endpoint}/${module.rds.Quality_RDS.db_name}

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

##############################
# FOR Transfer SQL File to RDS
##############################

resource "aws_instance" "RDS_file_transfer" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.Quality-SG.id]
  subnet_id = module.vpc.pubsubnet[0].id

  tags = { Name = "${var.pName}-EC2-RDS"}

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "./modules/ProjectRDS/RDS_Files/quality-bot.sql"
    destination = "/tmp/quality-bot.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install postgresql -y",
      "PGPASSWORD=${module.rds.Quality_RDS.password} psql  -f /tmp/quality-bot.sql -h ${module.rds.Quality_RDS.address}  -p ${module.rds.Quality_RDS.port}  -U ${module.rds.Quality_RDS.username}  --dbname ${module.rds.Quality_RDS.db_name}",
      "sudo poweroff"
    ]
  }
}
