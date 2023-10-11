output "application_endpoint" {
    value = aws_lb.sts_asg_infra_alb.dns_name
}
