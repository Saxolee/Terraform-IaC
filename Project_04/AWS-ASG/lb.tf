# Create an application load balancer
resource "aws_lb" "sts_asg_infra_alb" {
    name               = "sts-asg-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.sts_asg_infra_alb_sg.id]
    subnets            = [aws_subnet.sts_asg_infra_first_pub_subnet.id, aws_subnet.sts_asg_infra_second_pub_subnet.id]
}

# Create an application load balancer listener
resource "aws_lb_listener" "sts_asg_infra_alb_listener" {
    load_balancer_arn = aws_lb.sts_asg_infra_alb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.sts_asg_infra_alb_tg.arn
    }
}

# Create an application load balancer target group
resource "aws_lb_target_group" "sts_asg_infra_alb_tg" {
    name     = "sts-asg-target-group"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.sts_asg_infra_vpc.id
}
