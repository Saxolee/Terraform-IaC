output "sts_pub_1_ip" {
    value = aws_instance.sts_prod_2_instance.public_ip
}

output "sts_pub_2_ip" {
    value = aws_instance.sts_prod_2_instance.public_ip
}

# print the DNS of load balancer
output "sts_lb_dns_name" {
    description = "The DNS name of the load balancer"
    value       = aws_lb.sts_app_lb.dns_name
}