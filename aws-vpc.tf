resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "pub" {
  count = length(var.pub_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pub_subnet_cidrs[count.index]
  availability_zone = var.subnets_az[count.index]

  map_public_ip_on_launch = true

  tags = var.naming.tags
}


resource "aws_subnet" "priv" {
  count = length(var.priv_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.priv_subnet_cidrs[count.index]
  availability_zone = var.subnets_az[count.index]

  tags = var.naming.tags
}
