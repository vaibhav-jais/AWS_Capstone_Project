# Create Target Group
resource "aws_lb_target_group" "main" {
  name     = "Wordpress_server-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    path     = "/wp-login.php" #  WordPress health-check path
    protocol = "HTTP"
    port     = "traffic-port" # Use the port defined for the traffic
  }

  tags = {
    Name = "Wordpress_server-tg"
  }
}

# Create Application Load Balancer
resource "aws_lb" "main" {
  name               = "Wordpress_server-alb"
  internal           = false # Public-facing ALB
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]

  enable_deletion_protection = false

  tags = {
    Name = "Wordpress_server-alb"
  }
}

# Create Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# Data source to get the VPC ID
data "aws_vpc" "selected" {
  tags = {
    Name = var.vpc_name
  }
}
