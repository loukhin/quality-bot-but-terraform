module "loadbalancer" {
  source = "./modules/tom_loadbalancer"
  subnet_list = module.vpc.pubsubnet[*].id
  security_group_list = [aws_security_group.quality-internal-web.id]
  vpc_id = module.vpc.Quality_VPC.id
  cName = var.pName
}

resource "aws_autoscaling_attachment" "asg_tgp" {
  autoscaling_group_name = module.Music-asg.id
  lb_target_group_arn    = module.loadbalancer.tgp.id
}