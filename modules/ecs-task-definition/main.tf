
resource "aws_ecs_task_definition" "task_definition" {
  family = "service"
  requires_compatibilities = ["FARGATE"]  # Required for Fargate
  network_mode             = "awsvpc"  # Required for Fargate
  cpu                      = "256"  # Fargate requires CPU to be explicitly set
  memory                   = "512"  # Fargate requires memory to be explicitly set
  container_definitions = jsonencode([
    {
      name      = "${var.app_name}-${var.app_environment}-container"
      image     = "${var.app_container_image}"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = "${var.app_port}"
          hostPort      = "${var.app_port}"
        }
      ]
    }
  ])

#   volume {
#     name      = "service-storage"
#     host_path = "/ecs/service-storage"
#   }
}