module "rds" {
  source = "./modules/ProjectRDS"
  pName = var.pName
  username = var.rds_username
  password = var.rds_password
  
}