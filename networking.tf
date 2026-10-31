
# Internet Gateway attached to our VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "portfolio-project2-igw"
    Project     = "AWS-Cloud-Portfolio"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}


# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "portfolio-public-rt"
    Project     = "AWS-Cloud-Portfolio"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}


# Associate Public Subnet A
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# Associate Public Subnet B
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}
