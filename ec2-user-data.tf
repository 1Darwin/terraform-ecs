data "template_file" "user_data" {
  template = "${file("ec2_user_data_template.sh")}"

  vars = {
    ECS_ENV = "${var.environment_name}_cluster"
    EFS_DNS = "${aws_efs_file_system.efs.dns_name}"
    EFS_ID  = "${aws_efs_file_system.efs.id}"
  }
}
