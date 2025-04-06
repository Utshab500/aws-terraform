resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.listener_port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}