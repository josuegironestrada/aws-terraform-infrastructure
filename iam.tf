
# IAM role that EC2 can assume
resource "aws_iam_role" "ec2_ssm_role" {
  name = "portfolio-project2-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project   = "AWS-Cloud-Portfolio"
    ManagedBy = "Terraform"
  }
}

# Grant the instance access to Systems Manager
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile connects the IAM role to EC2
resource "aws_iam_instance_profile" "ec2" {
  name = "portfolio-project2-ec2-profile"
  role = aws_iam_role.ec2_ssm_role.name
}
