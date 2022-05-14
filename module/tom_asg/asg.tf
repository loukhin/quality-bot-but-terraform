

resource "aws_autoscaling_group" "asg" {
  max_size                  = max
  min_size                  = min
  health_check_grace_period = health_check
  health_check_type         = health_check_type
  desired_capacity          = desired
  force_delete              = force_delete
  vpc_zone_identifier       = subnet_list
  launch_template {
    id      = launch_configuration.id
    version = launch_configuration.latest_version
  }
  #tags =
}

