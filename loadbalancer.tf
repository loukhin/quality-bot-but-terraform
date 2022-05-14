module "loadbalancer" {
  
}

resource "aws_autoscaling_attachment" "asg_tgp" {
  autoscaling_group_name = aws_autoscaling_group.asg.id#music asg
  lb_target_group_arn    = aws_lb_target_group.test.arn
}