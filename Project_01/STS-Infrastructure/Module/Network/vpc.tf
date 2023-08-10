# Create a VPC (Virtual Private Cloud) with CIDR block
resource "aws_vpc" "sts_vpc" {
  cidr_block           = local.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge( {
    Name = local.name
  }, local.tags)
}

# Subnets
# Create Internet Gateway for Public Subnet and attach it to the VPC
resource "aws_internet_gateway" "sts_internet_gateway" {
  vpc_id = aws_vpc.sts_vpc.id
  tags   = merge({
    Name = "${local.name} Internet Gateway"
  }, local.tags)
}

# Create an EIP for NAT
resource "aws_eip" "sts_nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.sts_internet_gateway]
}

# Create a NAT Gateway
resource "aws_nat_gateway" "sts_nat_gateway" {
  allocation_id = aws_eip.sts_nat_eip.id
  subnet_id     = element(aws_subnet.sts_public_subnet.*.id, 0)

  tags = merge({
    Name = "${local.name} Nat Gateway"
  }, local.tags)
}

# Create a Public subnet with a CIDR block
resource "aws_subnet" "sts_public_subnet" {
  vpc_id                  = aws_vpc.sts_vpc.id
  count                   = length(local.public_subnets_cidr_block)
  cidr_block              = element(local.public_subnets_cidr_block, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags                    = merge( {
    Name = "${local.name} Public Subnet ${element(var.availability_zones, count.index)}"
  }, local.tags)
}

# Create a Private Subnet with a CIDR block
resource "aws_subnet" "sts_private_subnet" {
  vpc_id                  = aws_vpc.sts_vpc.id
  count                   = length(local.private_subnets_cidr_block)
  cidr_block              = element(local.private_subnets_cidr_block, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags                    = merge({
    Name = "${local.name} Private Subnet ${element(var.availability_zones, count.index)}"
  }, local.tags)
}


# Create a Routing tables to route traffic for Private Subnet
resource "aws_route_table" "sts_private" {
  vpc_id = aws_vpc.sts_vpc.id

  tags = merge({
    Name = "${local.name} Private Route Table"
  }, local.tags)
}

# Create a Routing tables to route traffic for Public Subnet
resource "aws_route_table" "sts_public" {
  vpc_id = aws_vpc.sts_vpc.id

  tags = merge({
    Name = "${local.name} Public Route Table"
  }, local.tags)
}

# Create a Route for Internet Gateway
resource "aws_route" "sts_public_internet_gateway" {
  route_table_id         = aws_route_table.sts_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sts_internet_gateway.id
}

# Create a Route for NAT Gateway
resource "aws_route" "sts_private_nat_gateway" {
  route_table_id         = aws_route_table.sts_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.sts_nat_gateway.id
}

# Create a Route table associations for Public Subnets
resource "aws_route_table_association" "sts_public" {
  count          = length(local.public_subnets_cidr_block)
  subnet_id      = element(aws_subnet.sts_public_subnet.*.id, count.index)
  route_table_id = aws_route_table.sts_public.id
}

# Create a Route table associations for Private Subnets
resource "aws_route_table_association" "sts_private" {
  count          = length(local.private_subnets_cidr_block)
  subnet_id      = element(aws_subnet.sts_private_subnet.*.id, count.index)
  route_table_id = aws_route_table.sts_private.id
}

