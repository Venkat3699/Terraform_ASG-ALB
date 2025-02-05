# Launch Configuration
resource "aws_launch_template" "app" {
  name          = "${var.env}-launch-configuration"
  image_id      = var.amis[var.region]
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data              = file("install_script.sh")
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "${var.env}-app-instance"
      env     = var.env
      project = var.project
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}

# Update Auto Scaling Group to register instances with the Target Group
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity    = 3
  max_size            = 5
  min_size            = 1
  vpc_zone_identifier = aws_subnet.public_subnet[*].id

  launch_template {
    id = aws_launch_template.app.id
  }

  # Attach the target group to the Auto Scaling Group from Load Balancer
  target_group_arns = [aws_lb_target_group.app_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.env}-app-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "project"
    value               = var.project
    propagate_at_launch = true
  }
}

# CloudWatch Alarm for scaling out
resource "aws_cloudwatch_metric_alarm" "scale_out" {
  alarm_name          = "${var.env}-scale-out"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This metric monitors EC2 CPU utilization"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

# CloudWatch Alarm for scaling in
resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_name          = "${var.env}-scale-in"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "This metric monitors EC2 CPU utilization"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}

# Scaling Policies
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.env}-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.env}-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}