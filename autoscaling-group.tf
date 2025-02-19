# Launch Template
resource "aws_launch_template" "wordpress" {
  name_prefix          = "LT_using_AMI_WordPress_Server-"
  image_id             = var.ec2_ami_id
  instance_type        = var.instance_type
  key_name             = "Capstone_Proj_KeyPair.pem"
  vpc_id               = data.aws_vpc.selected.id
  security_group_names = [aws_security_group.ec2.name]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "WordPress Server"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "wordpress" {
  name                = "ASG-WordPress-Server-using-CustomAMI"
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.public_az1.id, aws_subnet.public_az2.id] # Public subnets
  target_group_arns   = [aws_lb_target_group.main.arn]
  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }
}

data "aws_vpc" "selected" {
  tags = {
    Name = var.vpc_name
  }
}
