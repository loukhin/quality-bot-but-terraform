

resource "aws_autoscaling_group" "asg" {
  max_size                  = var.max
  min_size                  = var.min
  health_check_grace_period = var.health_check
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired
  force_delete              = var.force_delete
  vpc_zone_identifier       = var.subnet_list
  launch_configuration      = var.launch_configuration_name
  tag {
    key                 = "Name"
    value               = "${var.pName}-${var.type_of_instance}-server"
    propagate_at_launch = true
  }
}

