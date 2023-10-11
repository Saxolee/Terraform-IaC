# Create security group for the instances
resource "aws_security_group" "sts_asg_infra_instance_sg" {
    name = "sts_asg-instance-sg"

    # Dynamic block that creates two rules to allow inbound traffic 
    dynamic "ingress" {
        for_each = var.sts_asg_inbound_ec2
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
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = aws_vpc.sts_asg_infra_vpc.id
}

# Create application load balancer security group
resource "aws_security_group" "sts_asg_infra_alb_sg" {
    name = "sts-asg-alb-sg"
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

    vpc_id = aws_vpc.sts_asg_infra_vpc.id
}

