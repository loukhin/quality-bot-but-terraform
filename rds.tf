module "rds" {
  source = "./modules/ProjectRDS"
  pName = var.pName
  username = var.rds_username
  password = var.rds_password
  subnet_group_name = module.vpc.pubsubnet
}