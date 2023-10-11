resource "aws_launch_template" "sts_asg_infra_instances_config" {
    name_prefix            = "sts-asg-instance"
    image_id               = var.sts_asg_ami
    key_name               = var.sts_asg_key_name
    instance_type          = var.sts_asg_instance_type
    user_data              = filebase64("install_script.sh")
    vpc_security_group_ids = [aws_security_group.sts_asg_infra_instance_sg.id]

    lifecycle {
        create_before_destroy = true
    }

    tags = {
        Name = "sts-asg-instance"
    }

}

# Create an auto scaling group 
resource "aws_autoscaling_group" "sts_infra_asg" {
    name                      = "sts-asg"
    min_size                  = 2
    max_size                  = 4
    desired_capacity          = 2
    health_check_grace_period = 150
    health_check_type         = "ELB"
    vpc_zone_identifier       = [aws_subnet.sts_asg_infra_first_pub_subnet.id, aws_subnet.sts_asg_infra_second_pub_subnet.id]
    launch_template {
        id      = aws_launch_template.sts_asg_infra_instances_config.id
        version = "$Latest"
    }
}

# Create an auto scaling group policy
resource "aws_autoscaling_policy" "sts_asg_infra_avg_cpu_policy_greater" {
    name                   = "sts-avg-cpu-policy-greater"
    policy_type            = "TargetTrackingScaling"
    autoscaling_group_name = aws_autoscaling_group.sts_infra_asg.id
    # CPU Utilization is above 50
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
    }
}

# Create auto scaling group attachment
resource "aws_autoscaling_attachment" "sts_infra_asg_attachment" {
    autoscaling_group_name = aws_autoscaling_group.sts_infra_asg.id
    lb_target_group_arn    = aws_lb_target_group.sts_asg_infra_alb_tg.arn
}

