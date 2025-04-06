data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "${var.aws_service}"
        }
        Action = [ 
            "s3:GetBucketAcl",
            "s3:PutObject" 
        ]
        # Resource = "arn:aws:s3:::${var.bucket_arn}"
        Resource = [ 
            "arn:aws:s3:::${var.bucket_name}",
            "arn:aws:s3:::${var.bucket_name}/*"    
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_ownership_controls" "service_ownership" {
  bucket = var.bucket_id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}