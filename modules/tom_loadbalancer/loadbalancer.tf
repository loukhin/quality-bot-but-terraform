resource "aws_lb" "reqLB" {
    name = "web-elb"
    load_balancer_type = "application"
    internal = false
    subnets = aws_subnet.PublicNets[*].id #*คือทุกตัว
    security_groups = [aws_security_group.elb-sg.id]

    tags = #merge(local.common_tags, { Name = "${var.cName}-web-loadbalancer"})
}

resource "aws_lb_target_group" "tgp" {
  name = "tf-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.testVPC.id

  depends_on = [
    aws_lb.webLB
  ]

  tags = #merge(local.common_tags, { Name = "${var.cName}-tgp"})
}

resource "aws_lb_listener" "lbListener" {
  load_balancer_arn = aws_lb.webLB.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tgp.arn
    
  }

  tags = #merge(local.common_tags, { Name = "${var.cName}-listener"})
}
