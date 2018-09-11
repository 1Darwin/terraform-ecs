
resource "aws_lb_target_group" "lb_target_group" {
  name        = "tg-${var.environment_name}-${random_id.tg_randon_sufix.hex}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  # target_type = "ip"

  health_check {
    protocol            = "HTTP"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    path                = "/info.php"
    interval            = 30
    matcher             = "200-399"
  }

  lifecycle {
    create_before_destroy = true
  }
}