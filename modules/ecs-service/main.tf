data "aws_iam_role" "aws_service_role_for_ecs" {
  name = "AWSServiceRoleForECS"
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.service_name
  cluster         = var.cluster_id
  launch_type     = "FARGATE"
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count
  # iam_role        = data.aws_iam_role.aws_service_role_for_ecs.arn

#   ordered_placement_strategy {
#     type  = "binpack"
#     field = "cpu"
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.foo.arn
#     container_name   = "mongo"
#     container_port   = 8080
#   }

network_configuration {
  subnets          = var.subnet  # Replace with your actual subnets
  security_groups  = var.security_group  # Replace with your actual security group
  assign_public_ip = true  # Set to false if using private subnets
}

#   placement_constraints {
#     type       = "memberOf"
#     expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
#   }
}