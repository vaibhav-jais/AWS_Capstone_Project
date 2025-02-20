# Create S3 Bucket for Logs
resource "aws_s3_bucket" "wordpress_logs" {
  bucket = "lms-wordpress-server-logs"

  tags = {
    Name = "WordPress Logs Bucket"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.wordpress_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.wordpress_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
