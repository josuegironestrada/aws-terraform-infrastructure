
# Security Group for our future EC2 web server
resource "aws_security_group" "web" {
  name        = "portfolio-web-sg"
  description = "Security group for portfolio web server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "portfolio-web-sg"
    Project     = "AWS-Cloud-Portfolio"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# Inbound HTTP access
resource "aws_vpc_security_group_ingress_rule" "web_http" {
  security_group_id = aws_security_group.web.id

  description = "Allow HTTP from the internet"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

# Outbound HTTPS access
resource "aws_vpc_security_group_egress_rule" "web_https" {
  security_group_id = aws_security_group.web.id

  description = "Allow outbound HTTPS"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}
