# Target group attachment to register the backend instances
resource "aws_lb_target_group_attachment" "tg_attachement" {
  target_group_arn = var.target_group_arn
  target_id        = var.target_id
  port             = var.port
}