# Network Resources

# TODO Network ACLs
# Security groups with proper port bindings and WAF make network ACL
# redundant, in my opinion, but am happy to change for that extra redundancy

#TODO VPN - wireguard instance

# VPC
resource "aws_vpc" "default" {
  cidr_block = var.cidr_block

  tags = merge(local.tags, {
    Name = "${var.app_name}-vpc"
  })
}

# Subnets
# Public/private pairs for each az
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.1.0.0/20"
  availability_zone = "us-east-2a"

  tags = merge(local.tags, {
    Name = "${var.app_name}-public-subnet"
  })
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.1.16.0/20"
  availability_zone = "us-east-2b"

  tags = merge(local.tags, {
    Name = "${var.app_name}-public-subnet2"
  })
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.1.32.0/20"
  availability_zone = "us-east-2a"

  tags = merge(local.tags, {
    Name = "${var.app_name}-private-subnet"
  })
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.1.48.0/20"
  availability_zone = "us-east-2b"

  tags = merge(local.tags, {
    Name = "${var.app_name}-private-subnet2"
  })
}

# IGW
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = merge(local.tags, {
    Name = "igw"
  })
}

# Route Tables
resource "aws_default_route_table" "public" {
  default_route_table_id = aws_vpc.default.main_route_table_id

  tags = {
    Name = "${var.app_name}-public-route-table"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_default_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_default_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_default_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.app_name}-private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

# NAT
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${var.app_name} NAT"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id

  timeouts {
    create = "5m"
  }
}
