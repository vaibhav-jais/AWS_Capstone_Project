# Launch Template
resource "aws_launch_template" "wordpress" {
  name_prefix            = "LT_using_AMI_WordPress_Server-"
  image_id               = var.ec2_ami_id
  instance_type          = var.instance_type
  key_name               = "new_LMSserver_keypair"
  vpc_security_group_ids = [aws_security_group.ec2.id]

  iam_instance_profile {
    arn = aws_iam_role.ec2_s3_log_write.arn
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "WordPress Server"
    }
  }
  user_data = base64encode(file("user_data.sh"))

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
