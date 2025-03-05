resource "aws_ecs_task_definition" "task_definition" {
  family = "service"
  requires_compatibilities = ["FARGATE"]  # Required for Fargate
  network_mode             = "awsvpc"  # Required for Fargate
  cpu                      = "256"  # Fargate requires CPU to be explicitly set
  memory                   = "512"  # Fargate requires memory to be explicitly set
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn  # Role for Fargate
  container_definitions = jsonencode([
    {
      name      = "nginx-server"
      image     = "nginx:latest"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

#   volume {
#     name      = "service-storage"
#     host_path = "/ecs/service-storage"
#   }
}