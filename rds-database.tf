# RDS Subnet Group
resource "aws_db_subnet_group" "private_rds" {
  name       = "private-rds-subnet-group"
  subnet_ids = [aws_subnet.private_az1.id, aws_subnet.private_az2.id] # Private Subnets
}

# RDS Instance (MariaDB)
resource "aws_db_instance" "wordpress" {
  identifier             = "Wordpress-server-Database"
  allocated_storage      = 20 # Minimum value for db.t3.micro
  storage_type           = "gp2"
  engine                 = "mariadb"
  engine_version         = "10.6"
  instance_class         = var.db_instance_class
  port                   = 3306
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.private_rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  multi_az               = true                 # Enabling Multi-AZ
  availability_zone      = "${var.aws_region}a" # Primary AZ
  skip_final_snapshot    = true                 # Disabling final snapshot
}
