resource "aws_lb" "reqLB" {
    name = "requestmusic-elb"
    load_balancer_type = "application"
    internal = true
    subnets = var.subnet_list #*คือทุกตัว
    security_groups = var.security_group_list

    tags = { Name = "${var.cName}-request-loadbalancer"}
}

resource "aws_lb_target_group" "tgp" {
  name = "tf-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  depends_on = [
    aws_lb.reqLB
  ]

  tags = { Name = "${var.cName}-tgp"}
}

resource "aws_lb_listener" "lbListener" {
  load_balancer_arn = aws_lb.reqLB.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tgp.arn

  }

  tags = { Name = "${var.cName}-listener"}
}
