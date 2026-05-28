terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">=1.2.0"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

module "aws_vpc" {
  source     = "../../modules/vpc"
  tag_name   = "openclaw-vpc"
  cidr_block = "10.30.0.0/16"
}

module "aws_internet_gateway" {
  source   = "../../modules/ineternet-gateway"
  vpc_id   = module.aws_vpc.vpc_id
  tag_name = "openclaw-igw"
}

module "aws_route_table" {
  source   = "../../modules/route-table"
  vpc_id   = module.aws_vpc.vpc_id
  tag_name = "openclaw-rt"
  igw_id   = module.aws_internet_gateway.aws_igw_id
}

module "aws_subnet" {
  source           = "../../modules/subnet"
  tag_name         = "openclaw-subnet-1"
  cidr_block       = "10.30.1.0/24"
  vpc_id           = module.aws_vpc.vpc_id
  assign_public_ip = true
  route_table_id   = module.aws_route_table.route_table_id
}

module "security_group" {
  source   = "../../modules/security-group"
  vpc_id   = module.aws_vpc.vpc_id
  tag_name = "openclaw-sg"
  name     = "openclaw-sg"
}

resource "aws_iam_role" "ssm_role" {
  name = "openclaw-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "openclaw-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

module "ec2_instance" {
  source                 = "../../modules/ec2"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  subnet_id              = module.aws_subnet.subnet_id
  vpc_security_group_ids = [module.security_group.sg_id]
  volume_size            = 20
  user_data              = file("user-data.sh")
  tag_name               = "openclaw-ubuntu-spot-ec2"

  use_spot_instance = true
  spot_max_price    = null
}
