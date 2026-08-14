resource "aws_ecs_service" "ecs_service" {
  name            = "${var.app_name}-${var.app_environment}-service"
  cluster         = var.cluster_id
  launch_type     = "FARGATE"
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count

  network_configuration {
    subnets          = var.subnets  # Replace with your actual subnets
    security_groups  = var.security_groups  # Replace with your actual security group
    assign_public_ip = true  # Set to false if using private subnets
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.app_name}-${var.app_environment}-container"
    # container_name   = "nginx-server"
    container_port   = var.container_port
  }
}