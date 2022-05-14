module "loadbalancer" {
  sg_list = ""
  subnet_list = module.vpc.subnet_list
  vpc_id = module.vpc.Quality_VPC.id
  cName = var.pName
}

resource "aws_autoscaling_attachment" "asg_tgp" {
  autoscaling_group_name = module.Music-asg.id
  lb_target_group_arn    = module.loadbalancer.tgp.id
}