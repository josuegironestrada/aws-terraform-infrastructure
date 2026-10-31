
# AWS Region
variable "aws_region" {
  description = "AWS Region where regional resources are deployed"
  type        = string
  default     = "us-east-1"
}

# VPC CIDR block
variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# EC2 instance type
variable "instance_type" {
  description = "EC2 instance type for the web server"
  type        = string
  default     = "t3.micro"
}

# Deployment environment
variable "environment" {
  description = "Environment label used for resource tagging"
  type        = string
  default     = "Development"
}

# Project tag
variable "project_name" {
  description = "Project identifier for AWS resource tags"
  type        = string
  default     = "AWS-Cloud-Portfolio"
}
