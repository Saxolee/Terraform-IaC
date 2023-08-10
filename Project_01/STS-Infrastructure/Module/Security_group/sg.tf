# Create a Security Group to allow SSH and HTTP Access to the VPC
resource "aws_security_group" "sts_security_group" {
  name_prefix = "${local.name_prefix} Security Group"
  description = "Default SG to allow traffic from the VPC"
  vpc_id      = aws_vpc.sts_vpc.id
  depends_on  = [
    aws_vpc.sts_vpc
  ]

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${local.name_prefix} Security Group"
  }, local.tags)
}