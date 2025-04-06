resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.app_name}-${var.app_environment}-bucket"

  tags = {
    Name        = "${var.app_name}-${var.app_environment}-bucket"
    Environment = var.app_environment
  }
}