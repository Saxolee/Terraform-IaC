resource "aws_route_table" "sts_infra_route_tbl" {
    vpc_id = aws_vpc.sts_infra_vpc.id
    route {
    # associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"
    # CRT uses this IGW to reach internet
        gateway_id = aws_internet_gateway.sts_tier_architecture_igw.id
    }
}

# attach ec2 1 subnet to an internet gateway
resource "aws_route_table_association" "sts-route-ec2-1-subnet-to-igw" {
    subnet_id      = aws_subnet.sts_ec2_1_pub_subnet.id
    route_table_id = aws_route_table.sts_infra_route_tbl.id
}

# attach ec2 2 subnet to an internet gateway
resource "aws_route_table_association" "sts-route-ec2-2-subnet-to-igw" {
    subnet_id      = aws_subnet.sts_ec2_2_pub_subnet.id
    route_table_id = aws_route_table.sts_infra_route_tbl.id
}