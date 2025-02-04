# Configuring Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id     = aws_vpc.myvpc.id
  depends_on = [aws_internet_gateway.myigw]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
  tags = {
    Name    = "${var.env}_public_rt"
    env     = var.env
    project = var.project
  }
}

# Configuring Public Subnet Route Table Association
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
