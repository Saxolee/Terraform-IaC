resource "aws_vpc" "sts_infra_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true" # gives you an internal domain name
  enable_dns_hostnames = "true" # gives you an internal host name
  instance_tenancy     = "default"

  tags = {
    Name = "sts-2-tier-architecture-vpc"
  }
}

# It enables our vpc to connect to the internet
resource "aws_internet_gateway" "sts_tier_architecture_igw" {
  vpc_id = aws_vpc.sts_infra_vpc.id
  tags = {
    Name = "sts-2-tier-architecture-igw"
  }
}

# Create first ec2 instance public subnet
resource "aws_subnet" "sts_ec2_1_pub_subnet" {
  vpc_id                  = aws_vpc.sts_infra_vpc.id
  cidr_block              = var.subnet_cidrs[1]
  map_public_ip_on_launch = "true" # it makes this a public subnet
  availability_zone       = var.availability_zone[0]
  tags = {
    Name = "sts-first-ec2-public-subnet"
  }
}

# create second ec2 instance public subnet
resource "aws_subnet" "sts_ec2_2_pub_subnet" {
  vpc_id                  = aws_vpc.sts_infra_vpc.id
  cidr_block              = var.subnet_cidrs[2]
  map_public_ip_on_launch = "true" # it makes this a public subnet
  availability_zone       = var.availability_zone[1]
  tags = {
    Name = "sts-second-ec2-public-subnet"
  }
}

# Create database private subnet
resource "aws_subnet" "sts_db_prv_subnet" {
  vpc_id                  = aws_vpc.sts_infra_vpc.id
  cidr_block              = var.subnet_cidrs[4]
  map_public_ip_on_launch = "false" # it makes this a private subnet
  availability_zone       = var.availability_zone[1]
  tags = {
    Name = "sts-database-private-subnet"
  }
}

# Create database read replica private subnet
resource "aws_subnet" "sts_db_read_replica_prv_subnet" {
  vpc_id                  = aws_vpc.sts_infra_vpc.id
  cidr_block              = var.subnet_cidrs[3]
  map_public_ip_on_launch = "false"
  availability_zone       = var.availability_zone[0]
  tags = {
    Name = "sts-database-read-replica-private-subnet"
  }
}