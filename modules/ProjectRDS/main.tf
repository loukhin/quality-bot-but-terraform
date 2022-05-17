resource "aws_db_instance" "Quality_RDS" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.t3.micro"
  storage_type         = "gp2"
  publicly_accessible = true
  db_subnet_group_name = module.vpc.subnet_list[0].id
  db_name              = "${var.pName}Database"
  username             = var.username
  password             = var.password
  skip_final_snapshot  = true

  tags = { Name = "${var.pName}-RDS"}
}