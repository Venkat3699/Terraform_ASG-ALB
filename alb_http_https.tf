# # Application Load Balancer
# resource "aws_lb" "app_lb" {
#   name               = "${var.env}-app-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.app_sg.id]
#   subnets            = aws_subnet.public_subnet[*].id

#   enable_deletion_protection = false

#   tags = {
#     Name    = "${var.env}-app-lb"
#     env     = var.env
#     project = var.project
#   }
# }

# # Target Group for the Auto Scaling Group
# resource "aws_lb_target_group" "app_tg" {
#   name     = "${var.env}-app-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.myvpc.id

#   health_check {
#     path                = "/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }

#   tags = {
#     Name    = "${var.env}-app-tg"
#     env     = var.env
#     project = var.project
#   }
# }

# # Listener for HTTP (port 80) with redirect to HTTPS
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"
#     redirect {
#       host        = "#{host}"
#       path        = "/"
#       port        = "443"
#       protocol    = "HTTPS"
#       query       = "#{query}"
#       status_code = "HTTP_301"
#     }
#   }
# }

# # Listener for HTTPS (port 443)
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy       = "ELBSecurityPolicy-2016-08" # Choose an appropriate SSL policy
#   certificate_arn  = var.certificate_arn # Replace with your ACM certificate ARN

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app_tg.arn
#   }
# }