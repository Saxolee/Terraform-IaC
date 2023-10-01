# Create a security  group for production node to allow traffic 
resource "aws_security_group" "sts-prod-instance-sg" {
  name        = "sts-prod-instance-sg"
  description = "Security group to allow inbound traffic on port 22 and 9090"
  vpc_id      = aws_vpc.sts_infra_vpc.id

  # Dynamic block to create two rules to allow inbound traffic 
  dynamic "ingress" {
    for_each = var.inbound_port_production_ec2
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a security group for database to allow traffic on port 3306 and from ec2 production security group
resource "aws_security_group" "sts-db-sg" {
  name        = "sts-database-sg"
  description = "security  group for database to allow traffic on port 3306 and from ec2 production security group"
  vpc_id      = aws_vpc.sts_infra_vpc.id

  ingress {
    description     = "Allow traffic from port 3306 and from ec2 production security group"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sts-prod-instance-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an efs volume security group
resource "aws_security_group" "sts_efs_sg" {
  name        = "sts-efs-security-group"
  description = "Allow EFS PORT"
  vpc_id      = aws_vpc.sts_infra_vpc.id
  ingress {
    description     = "EFS mount target"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.sts-prod-instance-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}