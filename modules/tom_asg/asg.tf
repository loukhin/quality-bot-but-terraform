

resource "aws_autoscaling_group" "asg" {
  max_size                  = var.max
  min_size                  = var.min
  health_check_grace_period = var.health_check
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired
  force_delete              = var.force_delete
  vpc_zone_identifier       = var.subnet_list
  launch_template {
    id      = var.launch_configuration.id
    version = var.launch_configuration.latest_version
  }
  tags = { Name = "${var.pName}-asg"}
}

