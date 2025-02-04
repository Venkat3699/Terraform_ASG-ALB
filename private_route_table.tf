# Configuring Private Route Tables for each private subnet
resource "aws_route_table" "private_rt" {
  count  = length(aws_subnet.private_subnet)
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name    = "${var.env}_private_rt-${count.index + 1}"
    env     = var.env
    project = var.project
  }
}

# Configuring Private Subnet Route Table Association
resource "aws_route_table_association" "private_subnet_assoc" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}