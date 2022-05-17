module "rds" {
  source = "./modules/ProjectRDS"
  pName = var.pName
  username = var.rds_username
  password = var.rds_password
  subnet_id_list = module.vpc.pubsubnet[*].id
  securitygroup_id_list = [aws_security_group.Quality-RDS-SG.id]
}