resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "priv" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_route_table_association" "pub" {
	count = length(var.pub_subnet_cidrs)
	subnet_id      = aws_subnet.pub[count.index].id
	route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "priv" {
	count = length(var.priv_subnet_cidrs)
	subnet_id      = aws_subnet.priv[count.index].id
	route_table_id = aws_route_table.priv.id
}
