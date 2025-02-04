# Configuring Security Group
resource "aws_security_group" "app_sg" {
  name        = "allow_multiple_ports"
  description = "Security group to allow multiple ports"
  vpc_id      = aws_vpc.myvpc.id # Ensure the security group is associated with the correct VPC

  # Loop through allowed ports to create ingress rules
  dynamic "ingress" {
    for_each = var.allowed_ports
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
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}_Sg-tf"
    env  = "${var.env}"
  }
}