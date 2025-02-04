resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.myvpc.id
  count                   = length(var.public_subnet_cidr)
  cidr_block              = element(var.public_subnet_cidr, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.env}_public_subnet-${count.index + 1}"
    env     = var.env
    project = var.project
  }
}