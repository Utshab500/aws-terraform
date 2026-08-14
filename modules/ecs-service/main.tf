resource "aws_ecs_service" "ecs_service" {
  name            = var.service_name
  cluster         = var.cluster_id
  launch_type     = "FARGATE"
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count

  network_configuration {
    subnets          = var.subnet  # Replace with your actual subnets
    security_groups  = var.security_group  # Replace with your actual security group
    assign_public_ip = true  # Set to false if using private subnets
  }
}