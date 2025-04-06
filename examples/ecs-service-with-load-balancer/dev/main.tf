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

locals {
  app_name = "nginx-proxy"
  app_environment = "dev"
  app_port = 80
}

# Create a VPC
module "aws_vpc" {    
    source      = "../../../modules/vpc"
    tag_name    = "${local.app_name}-${local.app_environment}-vpc"
    cidr_block  = "10.3.0.0/16"
}

module "aws_internet_gateway" {
  source        = "../../../modules/ineternet-gateway"
  vpc_id        = module.aws_vpc.vpc_id
  tag_name      = "${local.app_name}-${local.app_environment}-IGW"
}

module "aws_route_table" {
  source        = "../../../modules/route-table"
  vpc_id        = module.aws_vpc.vpc_id
  tag_name      = "${local.app_name}-${local.app_environment}-RT"
  igw_id        = module.aws_internet_gateway.aws_igw_id
}

module "aws_subnet_1" {
  source        = "../../../modules/subnet"
  tag_name      = "${local.app_name}-${local.app_environment}-subnet-1"
  cidr_block    = "10.3.0.0/24"
  vpc_id        = module.aws_vpc.vpc_id
  assign_public_ip = true
  route_table_id = module.aws_route_table.route_table_id
  availability_zone = "${var.region}a"
}

module "aws_subnet_2" {
  source        = "../../../modules/subnet"
  tag_name      = "${local.app_name}-${local.app_environment}-subnet-2"
  cidr_block    = "10.3.1.0/24"
  vpc_id        = module.aws_vpc.vpc_id
  assign_public_ip = true
  route_table_id = module.aws_route_table.route_table_id
  availability_zone = "${var.region}b"
}

module "security_group" {
  source = "../../../modules/security-group"
  vpc_id = module.aws_vpc.vpc_id
  tag_name = "${local.app_name}-${local.app_environment}-web-DMZ"
  name = "${local.app_name}-${local.app_environment}-web-DMZ"
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
    cluster_name = "${local.app_name}-${local.app_environment}-cluster"
}

module "task_definition" {
  source = "../../../modules/ecs-task-definition"
}

module "target_group" {
  source = "../../../modules/lb-target-group"
  app_name = local.app_name
  app_environment = local.app_environment
  vpc_id = module.aws_vpc.vpc_id
  port = local.app_port
}

module "service" {
  source = "../../../modules/ecs-service-with-lb"
  cluster_id = module.aws_ecs_cluster.cluster_id
  task_definition_arn = module.task_definition.task_definition_arn
  app_name = local.app_name
  app_environment = local.app_environment
  desired_count = 1
  target_group_arn = module.target_group.target_group_arn
  container_port = local.app_port
  subnets = [ module.aws_subnet_1.subnet_id, module.aws_subnet_2.subnet_id ]
  security_groups = [ module.security_group.sg_id ]
}

module "load_balancer" {
  source = "../../../modules/application-loadbalancer"
  app_name = local.app_name
  app_environment = local.app_environment
  subnet_ids = [ module.aws_subnet_1.subnet_id, module.aws_subnet_2.subnet_id ]
  security_group_ids = [ module.security_group.sg_id ]
}

module "alb_listener" {
  source = "../../../modules/lb-listener"
  load_balancer_arn = module.load_balancer.lb_arn
  listener_port = local.app_port
  protocol = "HTTP"
  target_group_arn = module.target_group.target_group_arn 
}