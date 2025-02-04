resource "aws_eip" "nat_eip" {
  count      = length(aws_subnet.private_subnet)
  domain     = "vpc"
  depends_on = [aws_internet_gateway.myigw]

  tags = {
    Name    = "${var.env}_eip-${count.index + 1}"
    env     = var.env
    project = var.project
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(aws_subnet.private_subnet)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name    = "${var.env}_nat_gw-${count.index + 1}"
    env     = var.env
    project = var.project
  }
}