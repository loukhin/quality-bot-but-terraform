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


# module "rds" {
#   source = "./modules/ProjectRDS"
#   pName = var.pName
#   username = var.username
#   password = var.password
  
# }

resource "aws_instance" "testweb" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  key_name               = var.key_name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("C:/Users/Acer/Desktop/Homework/Year3_HW/NPA/Project/key.pem")
  }
  
  provisioner "file" {
    source      = "C:/Users/Acer/Desktop/Homework/Year3_HW/NPA/Project/modules/ProjectRDS/RDS_Files/quality-bot.sql"
    destination = "/tmp/quality-bot.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install mysql -y",
      # "mysql -h ${module.rds.Quality_RDS.address} -p ${module.rds.Quality_RDS.port} -u ${module.rds.Quality_RDS.username} -p",
      # "${module.rds.Quality_RDS.password}",
      # "source /tmp/quality-bot.sql"
    ]
  }
}

output "aws_instance_public_dns" {
  value = aws_instance.testweb.public_dns
}
