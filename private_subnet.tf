resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.myvpc.id
  count             = length(var.private_subnet_cidr)
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = var.azs[count.index]

  tags = {
    Name    = "${var.env}_private_subnet-${count.index + 1}"
    env     = var.env
    project = var.project
  }
}