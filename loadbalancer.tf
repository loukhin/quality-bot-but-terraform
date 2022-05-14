resource "aws_lb" "webLB" {
    name = "web-elb"
    load_balancer_type = "application"
    internal = false
    subnets = module.vpc.PublicNets[*].id
    security_groups = [aws_security_group.elb-sg.id]

    tags = merge(local.common_tags, { Name = "${var.cName}-web-loadbalancer"})
}


resource "aws_lb_listener" "lbListener" {
  load_balancer_arn = aws_lb.webLB.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tgp.arn
    
  }

 tags = merge(local.common_tags, { Name = "${var.cName}-listener"})
}
