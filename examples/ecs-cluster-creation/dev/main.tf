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

# Create a VPC
module "aws_vpc" {    
    source      = "../../../modules/vpc"
    tag_name    = "my-ecs-vpc"
    cidr_block  = "10.3.0.0/16"
}

module "aws_internet_gateway" {
  source        = "../../../modules/ineternet-gateway"
  vpc_id        = module.aws_vpc.vpc_id
  tag_name      = "my-IGW"
}

module "aws_route_table" {
  source        = "../../../modules/route-table"
  vpc_id        = module.aws_vpc.vpc_id
  tag_name      = "my-RT"
  igw_id        = module.aws_internet_gateway.aws_igw_id
}

module "aws_subnet" {
  source        = "../../../modules/subnet"
  tag_name      = "my-subnet-1"
  cidr_block    = "10.3.0.0/24"
  vpc_id        = module.aws_vpc.vpc_id
  assign_public_ip = true
  route_table_id = module.aws_route_table.route_table_id
}

module "security_group" {
  source = "../../../modules/security-group"
  vpc_id = module.aws_vpc.vpc_id
  tag_name = "web-DMZ"
  name = "web-DMZ"
}

module "http_ingress_rule" {
  source = "../../../modules/security-group-rule"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = module.security_group.sg_id
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
  subnet = [ module.aws_subnet.subnet_id ]
  security_group = [ module.security_group.sg_id ]
}
