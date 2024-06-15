terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }

  required_version = ">=1.2.0"
}

provider "aws" {
    profile = var.profile
    region  = var.region
}

module "aws_vpc" {    
    source      = "../../modules/vpc"
    tag_name    = "my-vpc"
    cidr_block  = "10.3.0.0/16"
}

module "aws_internet_gateway" {
  source        = "../../modules/ineternet-gateway"
  vpc_id        = module.aws_vpc.vpc_id
  tag_name      = "my-IGW"
}

module "aws_route_table" {
  source        = "../../modules/route-table"
  vpc_id        = module.aws_vpc.vpc_id
  tag_name      = "my-RT"
  igw_id        = module.aws_internet_gateway.aws_igw_id
}

module "aws_subnet" {
  source        = "../../modules/subnet"
  tag_name      = "my-subnet-1"
  cidr_block    = "10.3.0.0/24"
  vpc_id        = module.aws_vpc.vpc_id
  assign_public_ip = true
  route_table_id = module.aws_route_table.route_table_id
}

module "security_group" {
  source = "../../modules/security-group"
  vpc_id = module.aws_vpc.vpc_id
  tag_name = "web-DMZ"
  name = "web-DMZ"
}

module "ssh_ingress_rule" {
  source = "../../modules/security-group-rule"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = module.security_group.sg_id
}

module "http_ingress_rule" {
  source = "../../modules/security-group-rule"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = module.security_group.sg_id
}

module "ec2_instance" {
  source = "../../modules/ec2"
  ami = "ami-003c463c8207b4dfa"
  key_name = "utshab-key"
  subnet_id = module.aws_subnet.subnet_id
  vpc_security_group_ids = [ module.security_group.sg_id ]
  volume_size = 10   # Default is set to 8GB
  user_data = file("user-data.sh")
  tag_name = "my-test-vm"
}
