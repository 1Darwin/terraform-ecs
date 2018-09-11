resource "aws_launch_configuration" "ecs-launch-configuration" {
  name_prefix          = "lc-${var.environment_name}"
  image_id             = "ami-644a431b"
  instance_type        = "t2.medium"
  iam_instance_profile = "${aws_iam_instance_profile.instProfile.name}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 60
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = ["${aws_security_group.ecs_securitygroup.id}"]
  associate_public_ip_address = "true"
  key_name                    = "${var.ecs_key_pair_name}"

  user_data = "${data.template_file.user_data.rendered}"
}
