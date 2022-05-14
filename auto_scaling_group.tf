module "Manager1-asg" {
  launch_configuration = aws_launch_configuration#.name
  min = 1
  max = 1
  desired = 1
  health_check = 300
  health_check_type = "ELB"
  force_delete = true
  subnet_list = "aws_vpc.public[*]"

}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = ""
  elb                    = ""
}

