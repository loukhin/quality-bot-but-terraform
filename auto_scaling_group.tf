module "Manager1-asg" {
  source = "./module/tom_asg"
  launch_configuration = aws_launch_configuration#.name
  min = 1
  max = 1
  desired = 1
  health_check = 300
  health_check_type = "ELB"
  force_delete = true
  subnet_list = "aws_vpc.public[*]"
  cName = var.pName
}

module "Manager2-asg" {
  source = "./module/tom_asg"
  launch_configuration = aws_launch_configuration#.name
  min = 1
  max = 1
  desired = 1
  health_check = 300
  health_check_type = "ELB"
  force_delete = true
  subnet_list = "aws_vpc.public[*]"
  cName = var.pName

}

module "Music-asg" {
  source = "./module/tom_asg"
  launch_configuration = aws_launch_configuration#.name
  min = var.amonut_music_instance[0]
  max = var.amonut_music_instance[2]
  desired = var.amonut_music_instance[1]
  health_check = 300
  health_check_type = "ELB"
  force_delete = true
  subnet_list = module.subnet_list[*]
  cName = var.pName

}

