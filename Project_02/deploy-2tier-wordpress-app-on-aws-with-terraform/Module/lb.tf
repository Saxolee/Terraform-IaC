# Create application Load Balancer
resource "aws_lb" "sts_app_lb" {
    name               = "sts-app-loadbalancer"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.sts-prod-instance-sg.id]
    subnets            = [aws_subnet.sts_ec2_2_pub_subnet.id, aws_subnet.sts_ec2_1_pub_subnet.id]
}

# Create Target group for application load balancer
resource "aws_lb_target_group" "sts_tg_grp_alb" {
    name     = "sts-target-group-alb"
    port     = var.target_application_port
    protocol = "HTTP"
    vpc_id   = aws_vpc.sts_infra_vpc.id
}

# Attach the target group to the first instance
resource "aws_lb_target_group_attachment" "sts_attach1" {
  target_group_arn = aws_lb_target_group.sts_tg_grp_alb.arn
  target_id        = aws_instance.sts_prod_1_instance.id
  port             = var.target_application_port
  depends_on = [
      aws_instance.sts_prod_1_instance,
  ]
}

# Attach a target group to the second instance
resource "aws_lb_target_group_attachment" "sts_attach2" {
    target_group_arn = aws_lb_target_group.sts_tg_grp_alb.arn
    target_id        = aws_instance.sts_prod_2_instance.id
    port             = var.target_application_port
    depends_on = [
        aws_instance.sts_prod_2_instance,
    ]
}

# Attach target group to a load balancer
resource "aws_lb_listener" "sts_ext_elb" {
    load_balancer_arn = aws_lb.sts_app_lb.arn
    port              = var.target_application_port
    protocol          = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.sts_tg_grp_alb.arn
    }
}