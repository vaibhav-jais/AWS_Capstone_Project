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

# IAM Policy for EC2 Instances to Write Logs to S3
resource "aws_iam_policy" "s3_log_write" {
  name        = "EC2-S3-Log-Write-Policy"
  description = "Allows EC2 instances to write logs to the WordPress Logs S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.wordpress_logs.arn,
          "${aws_s3_bucket.wordpress_logs.arn}/*"
        ]
      }
    ]
  })
}

# IAM Role for EC2 Instances
resource "aws_iam_role" "ec2_s3_log_write" {
  name = "EC2-S3-Log-Write-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the IAM Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "ec2_s3_log_write_attachment" {
  role       = aws_iam_role.ec2_s3_log_write.name
  policy_arn = aws_iam_policy.s3_log_write.arn
}
