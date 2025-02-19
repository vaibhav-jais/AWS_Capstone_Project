variable "bucket_name" {
  type        = string
  description = "Remote state bucket name"
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "us_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "LMS_WordPress_VPC"
}

variable "public_subnet_cidr_az1" {
  type    = string
  default = "10.0.1.0/26"
}

variable "public_subnet_cidr_az2" {
  type    = string
  default = "10.0.2.0/26"
}

variable "private_subnet_cidr_az1" {
  type    = string
  default = "10.0.3.0/26"
}

variable "private_subnet_cidr_az2" {
  type    = string
  default = "10.0.4.0/26"
}

variable "ec2_ami_id" {
  type        = string
  description = "AMI ID for the EC2 instances"
  default     = "ami-xxxxxxxxxxxxx" # Replace with a valid AMI ID
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.micro"
}
