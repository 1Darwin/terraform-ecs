resource "random_id" "tg_randon_sufix" {
  byte_length = 2
}

resource "aws_lb" "lb" {
  name            = "lb-${var.environment_name}-${random_id.tg_randon_sufix.hex}"
  subnets         = ["${split(",", data.terraform_remote_state.vpc.public_subnets)}"]
  security_groups = ["${aws_security_group.lb_securitygroup.id}"]

  tags {
    Name = "load Balance"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "80"
  protocol          = "HTTP"
  depends_on        = ["aws_lb_target_group.lb_target_group"]

  default_action {
    target_group_arn = "${aws_lb_target_group.lb_target_group.arn}"
    type             = "forward"
  }
}