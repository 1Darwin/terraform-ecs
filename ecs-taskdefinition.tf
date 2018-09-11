data "template_file" "template" {
  template = "${file("${path.module}/tasks/template.json")}"

  vars {
    EFS_DNS               = "${aws_efs_file_system.efs.dns_name}"
    docker_image          = "${var.docker_image}:${var.image_tag}"
    log_group             = "${aws_cloudwatch_log_group.cwlogs.name}"
    environment_name      = "${var.environment_name}"
    source_volume_1       = "${var.source_volume_1}"
    container_path_1      = "${var.container_path_1}"
    wp_db_host            = "${aws_rds_cluster.aurora.endpoint}"
    wp_db_host_slave      = "${aws_rds_cluster.aurora.reader_endpoint}"
    wp_db_user            = "${var.wp_db_user}"
    wp_db_password        = "${var.wp_db_password}"
    wp_db_name            = "${var.wp_db_name}"
    wp_current_domain     = "${var.wp_current_domain}"
    sendgrid_api_token    = "${var.sendgrid_api_token}"
    as3cf_access_key      = "${var.as3cf_access_key}"
    as3cf_secret_key      = "${var.as3cf_secret_key}"
    newrelic_app_name     = "${var.newrelic_app_name}"
    newrelic_license_key  = "${var.newrelic_license_key}"
  }
}

resource "aws_ecs_task_definition" "taskdef" {
  family                   = "${var.environment_name}"
  container_definitions    = "${data.template_file.template.rendered}"
  requires_compatibilities = ["EC2"]
  # network_mode             = "bridge"
  cpu                      = "2048"
  memory                   = "3584"
  execution_role_arn       = "${aws_iam_role.ecs_task.arn}"
  volume {
    name      = "uploads"
    host_path = "/data/uploads",
  }
}