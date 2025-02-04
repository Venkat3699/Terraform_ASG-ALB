resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name    = "${var.env}_vpc"
    env     = var.env
    project = var.project
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name    = "${var.env}_igw"
    env     = var.env
    project = var.project
  }
}