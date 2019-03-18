resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${terraform.workspace}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${terraform.workspace}-public-rt"
  }
}

resource "aws_route_table_association" "public_1" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_1.id}"
}

resource "aws_route_table_association" "public_2" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_2.id}"
}

resource "aws_route_table_association" "public_3" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_3.id}"
}
