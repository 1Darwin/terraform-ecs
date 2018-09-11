# cloudwatch log group
resource "aws_cloudwatch_log_group" "cwlogs" {
  name = "${var.environment_name}"

  tags {
    Application = "${var.environment_name}"
  }
}