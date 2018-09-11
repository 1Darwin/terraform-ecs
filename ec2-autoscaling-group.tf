resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name                 = "asg-${var.environment_name}"
  max_size             = "${var.asg_node_max}"
  min_size             = "${var.asg_node_min}"
  desired_capacity     = "${var.asg_node_des}"
  enabled_metrics      = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  vpc_zone_identifier  = ["${split(",", data.terraform_remote_state.vpc.public_subnets)}"]
  launch_configuration = "${aws_launch_configuration.ecs-launch-configuration.name}"
  target_group_arns    = ["${aws_lb_target_group.lb_target_group.arn}"]
  health_check_type    = "EC2"
  tag {
    key                 = "Name"
    value               = "${var.environment_name}"
    propagate_at_launch = true
  }
  tag {
    key                 = "ENV"
    value               = "TAG"
    propagate_at_launch = true
  }
}
