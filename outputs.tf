
output "vpc_id" {
  description = "ID of the Terraform-managed VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

output "web_server_public_ip" {
  description = "Public IPv4 address of the EC2 web server"
  value       = aws_instance.web.public_ip
}

output "web_server_url" {
  description = "HTTP URL of the demonstration website"
  value       = "http://${aws_instance.web.public_ip}"
}
