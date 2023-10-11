# Create a route table
resource "aws_route_table" "sts_asg_infra_route_tbl" {
    vpc_id = aws_vpc.sts_asg_infra_vpc.id

    route {
        cidr_block = "0.0.0.0/0" # associated subnet can reach everywhere
        gateway_id = aws_internet_gateway.sts_asg_infra_igw.id # use this IGW to reach internet
    }

}

# attach first public subnet to the internet gateway
resource "aws_route_table_association" "sts-asg-infra-route-ec2-1-subnet-to-igw" {
    subnet_id      = aws_subnet.sts_asg_infra_first_pub_subnet.id
    route_table_id = aws_route_table.sts_asg_infra_route_tbl.id
}

# attach second public subnet to the internet gateway
resource "aws_route_table_association" "sts-asg-infra-route-ec2-2-subnet-to-igw" {
    subnet_id      = aws_subnet.sts_asg_infra_second_pub_subnet.id
    route_table_id = aws_route_table.sts_asg_infra_route_tbl.id
}
