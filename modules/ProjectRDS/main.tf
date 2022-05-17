resource "aws_db_subnet_group" "Quality-subnet-group" {
  name       = "rds_db_group"
  subnet_ids = var.subnet_id_list

  tags = { Name = "${var.pName}-DB-subnet-group" }
}

resource "aws_db_instance" "Quality_RDS" {
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "13.4"
  instance_class         = "db.t3.micro"
  storage_type           = "gp2"
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.Quality-subnet-group.name
  vpc_security_group_ids = var.securitygroup_id_list
  db_name                = "${var.pName}Database"
  username               = var.username
  password               = var.password
  skip_final_snapshot    = true

  tags = { Name = "${var.pName}-RDS" }
}
