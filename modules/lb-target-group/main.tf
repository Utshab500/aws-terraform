resource "aws_lb_target_group" "alb_tg" {
  name        = "${var.app_name}-${var.app_environment}-alb-tg"
  target_type = "ip"
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}