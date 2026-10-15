# VPC
resource "aws_vpc" "ba_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name  = "ba_vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "ba_gw" {
  vpc_id = aws_vpc.ba_vpc.id

  tags = {
    Name  = "ba_gw"
  }
}
# Private Subnet
resource "aws_subnet" "ba_subnet_private" {
  vpc_id            = aws_vpc.ba_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    group = var.stack_name
    Name  = "ba_subnet_private"
  }
}
# Public Subnet
resource "aws_subnet" "ba_subnet_public" {
  vpc_id                  = aws_vpc.ba_vpc.id
  cidr_block              = "10.0.101.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"
  tags = {
    Name  = "ba_subnet_public"
  }
}
# Public Route Table
resource "aws_route_table" "ba_rt_public" {
  vpc_id = aws_vpc.ba_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ba_gw.id
  }

  tags = {
    Name  = "ba-rt-public"
  }
}
# Private Route Table Association
resource "aws_route_table_association" "ba_rta_public" {
  subnet_id      = aws_subnet.ba_subnet_public.id
  route_table_id = aws_route_table.ba_rt_public.id
}
# NAT Gateway
resource "aws_nat_gateway" "ba_nat_gw" {
  allocation_id = aws_eip.ba_eip.id
  subnet_id     = aws_subnet.ba_subnet_public.id

  tags = {
    Name  = "ba_nat_gw"
  }
}
# Elastic IP for NAT Gateway
resource "aws_eip" "ba_eip" { ## eip stands here elastic IP for the NAT gateway
  tags = {
    Name  = "ba_eip"
  }
}
# Private Route Table
resource "aws_route_table" "ba_rt_private" {
  vpc_id = aws_vpc.ba_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ba_gw.id
  }

  tags = {
    Name  = "ba-rt-private"
  }
}

resource "aws_route_table_association" "ba_rta_private" {
  subnet_id      = aws_subnet.ba_subnet_private.id
  route_table_id = aws_route_table.ba_rt_private.id
}
