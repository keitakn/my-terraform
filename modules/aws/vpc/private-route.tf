resource "aws_eip" "nat_ip_1" {
  tags = {
    Name = "${terraform.workspace}-nat-ip-1"
  }
}

resource "aws_eip" "nat_ip_2" {
  tags = {
    Name = "${terraform.workspace}-nat-ip-2"
  }
}

resource "aws_eip" "nat_ip_3" {
  tags = {
    Name = "${terraform.workspace}-nat-ip-3"
  }
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_ip_1.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "${terraform.workspace}-1"
  }
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_ip_2.id
  subnet_id     = aws_subnet.public_2.id

  tags = {
    Name = "${terraform.workspace}-2"
  }
}

resource "aws_nat_gateway" "nat_3" {
  allocation_id = aws_eip.nat_ip_3.id
  subnet_id     = aws_subnet.public_3.id

  tags = {
    Name = "${terraform.workspace}-3"
  }
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }

  tags = {
    Name = "${terraform.workspace}-private-rt-1"
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_2.id
  }

  tags = {
    Name = "${terraform.workspace}-private-rt-2"
  }
}

resource "aws_route_table" "private_3" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_3.id
  }

  tags = {
    Name = "${terraform.workspace}-private-rt-3"
  }
}

resource "aws_route_table_association" "private_1" {
  route_table_id = aws_route_table.private_1.id
  subnet_id      = aws_subnet.private_1.id
}

resource "aws_route_table_association" "private_app_2" {
  route_table_id = aws_route_table.private_2.id
  subnet_id      = aws_subnet.private_2.id
}

resource "aws_route_table_association" "private_app_3" {
  route_table_id = aws_route_table.private_3.id
  subnet_id      = aws_subnet.private_3.id
}
