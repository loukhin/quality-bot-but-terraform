module "Manager1-asg" {
  source = "./modules/tom_asg"
  launch_configuration = aws_launch_configuration.name
  min = var.text_group_size[0]
  max = var.text_group_size[2]
  desired = var.text_group_size[1]
  health_check = 300
  health_check_type = "ELB"
  force_delete = true
  subnet_list = module.vpc.pubsubnet
  cName = var.pName
}

module "Manager2-asg" {
  source = "./modules/tom_asg"
  launch_configuration = aws_launch_configuration.name
  min = var.text_group_size[0]
  max = var.text_group_size[2]
  desired = var.text_group_size[1]
  health_check = 300
  health_check_type = "ELB"
  force_delete = true
  subnet_list = module.vpc.pubsubnet
  cName = var.pName

}

module "Music-asg" {
  source = "./modules/tom_asg"
  launch_configuration = aws_launch_configuration.name
  min = var.music_group_size[0]
  max = var.music_group_size[2]
  desired = var.music_group_size[1]
  health_check = 300
  health_check_type = "ELB"
  force_delete = true
  subnet_list = module.vpc.pubsubnet  
  cName = var.pName

}

