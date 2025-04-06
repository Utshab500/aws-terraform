module "s3_log_bucket" {
  source = "../s3"
  app_name = var.app_name
  app_environment = var.app_environment
}

module "aws_s3_bucket_policy" {
  source = "../s3-bucket-policy"
  bucket_id = module.s3_log_bucket.id
  bucket_name = module.s3_log_bucket.name
  bucket_arn = module.s3_log_bucket.arn
  aws_service = "elasticloadbalancing.amazonaws.com"
}

resource "aws_lb" "alb" {
  name               = "${var.app_name}-${var.app_environment}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = module.s3_log_bucket.id
  #   prefix  = "${var.app_name}-${var.app_environment}-lb"
  #   enabled = true
  # }

  access_logs {
    bucket  = module.s3_log_bucket.id
    enabled = false
  }

  tags = {
    Environment = var.app_environment
  }
}