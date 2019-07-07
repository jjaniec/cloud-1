resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.pub[0].id
}

resource "aws_eip" "natgw" {
  vpc      = true
}
