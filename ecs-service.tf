resource "aws_ecs_service" "ecsservices" {
  name                              = "${var.environment_name}"
  iam_role                          = "${aws_iam_role.ecs-service-role.arn}"
  cluster                           = "${aws_ecs_cluster.cluster.id}"
  launch_type                       = "EC2"
  task_definition                   = "${aws_ecs_task_definition.taskdef.arn}"
  health_check_grace_period_seconds = 3600
  desired_count                     = "4"

  lifecycle {
    ignore_changes = ["desired_count", "task_definition"]
  }
  # network_configuration = {
  #   subnets         = ["${var.subnet_1}", "${var.subnet_2}", "${var.subnet_3}"]
  #   security_groups = ["${aws_security_group.ecs_securitygroup.id}"]
  # }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.lb_target_group.arn}"
    container_name   = "${var.environment_name}"
    container_port   = 80
  }

  depends_on = [
    "aws_lb_listener.http",
  ]
}