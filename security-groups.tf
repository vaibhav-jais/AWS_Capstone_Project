# Security Group for the Application Load Balancer
resource "aws_security_group" "alb" {
  name        = "LMS_Wordpress_ALB-SG"
  description = "Security group for the Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "LMS_Wordpress_ALB_SG"
  }
}

# Security Group for EC2 Instances
resource "aws_security_group" "ec2" {
  name        = "LMS_Wordpress_EC2-SG"
  description = "Security group for EC2 instances (WordPress servers)"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP/HTTPS from the ALB security group
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Allow SSH from internet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: Restrict this in a real environment
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "LMS_Wordpress_EC2-SG"
  }
}

# Security Group for RDS Database
resource "aws_security_group" "rds" {
  name        = "LMS_Wordpress_RDS-SG"
  description = "Security group for the RDS database"
  vpc_id      = aws_vpc.main.id

  # Allow MySQL/Aurora traffic from the EC2 security group
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "LMS_Wordpress_RDS-SG"
  }
}

# Data source to get the VPC ID
data "aws_vpc" "selected" {
  tags = {
    Name = var.vpc_name
  }
}
