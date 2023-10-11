# Create VPC Infrastructure with a CIDR Block
resource "aws_vpc" "sts_asg_infra_vpc" {
    cidr_block           = var.sts_asg_vpc_cidr
    enable_dns_support   = "true" # gives you an internal domain name
    enable_dns_hostnames = "true" # gives you an internal host name
    instance_tenancy     = "default"

    tags = {
        Name = "sts-asg-vpc"
    }
}

# Create Internet Gateway to allow the vpc to connect to the internet
resource "aws_internet_gateway" "sts_asg_infra_igw" {
    vpc_id = aws_vpc.sts_asg_infra_vpc.id
    tags = {
        Name = "sts-asg-igw"
    }
}

# Create first public subnet
resource "aws_subnet" "sts_asg_infra_first_pub_subnet" {
    vpc_id                  = aws_vpc.sts_asg_infra_vpc.id
    cidr_block              = var.sts_asg_pub_subnet_cidrs[0]
    map_public_ip_on_launch = "true" # assigned a public IP address.
    availability_zone       = var.sts_asg_availability_zone[0]
    tags = {
        Name = "sts-asg-first-pub-subnet"
    }
}

# Create second public subnet
resource "aws_subnet" "sts_asg_infra_second_pub_subnet" {
    vpc_id                  = aws_vpc.sts_asg_infra_vpc.id
    cidr_block              = var.sts_asg_pub_subnet_cidrs[1]
    map_public_ip_on_launch = "true" # assigned a public IP address.
    availability_zone       = var.sts_asg_availability_zone[1]
    tags = {
        Name = "sts-asg-second-pub-subnet"
    }
}

