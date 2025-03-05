terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.87.0"
        }
    }

  required_version = ">=1.2.0"
}

provider "aws" {
    profile = var.profile
    region  = var.region
}

module aws_ecs_cluster {
    source = "../../../modules/ecs"
    cluster_name = "my-test-cluster"
}

module "task_definition" {
  source = "../../../modules/ecs-task-definition"
}

module "service" {
  source = "../../../modules/ecs-service"
  cluster_id = module.aws_ecs_cluster.cluster_id
  service_name = "nginx-web-service"
  task_definition_arn = module.task_definition.task_definition_arn
  desired_count = 1
}
