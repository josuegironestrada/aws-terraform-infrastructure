
# Get the current Amazon Linux 2023 AMI
data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Our first EC2 instance
resource "aws_instance" "web" {
  user_data_replace_on_change = true
  ami                         = data.aws_ssm_parameter.amazon_linux.value
  instance_type               = "t3.micro"

  subnet_id = aws_subnet.public_a.id

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2.name

  user_data = file("${path.module}/user-data.sh")

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = "portfolio-project2-web-server"
    Project     = "AWS-Cloud-Portfolio"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# Display the instance's public IP
output "web_server_public_ip" {
  description = "Public IPv4 address of the web server"
  value       = aws_instance.web.public_ip
}

# Display its public HTTP URL
output "web_server_url" {
  description = "HTTP URL for the demonstration website"
  value       = "http://${aws_instance.web.public_ip}"
}
