


resource "aws_db_instance" "Quality_RDS" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  storage_type         = "gp2"
  publicly_accessible = true
  db_name              = "${var.pName}Database"
  username             = var.username
  password             = var.password
  skip_final_snapshot  = true

}