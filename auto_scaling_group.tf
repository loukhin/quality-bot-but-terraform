module "Manager-asg" {
  source = "./modules/tom_asg"
  count = var.text_instance_count
  launch_configuration_name = aws_launch_configuration.manager_conf[count.index].name
  min = var.text_group_size[0]
  max = var.text_group_size[2]
  desired = var.text_group_size[1]
  health_check = 300
  health_check_type = "ELB"
  force_delete = true
  subnet_list = module.vpc.pubsubnet[*].id
  pName = var.pName
  type_of_instance = "manager${count.index + 1}"
}

module "Music-asg" {
  source = "./modules/tom_asg"
  launch_configuration_name = aws_launch_configuration.voice_conf.name
  min = var.music_group_size[0]
  max = var.music_group_size[2]
  desired = var.music_group_size[1]
  health_check = 300
  health_check_type = "ELB"
  force_delete = true
  subnet_list = module.vpc.pubsubnet[*].id
  pName = var.pName
  type_of_instance = "music"
}

