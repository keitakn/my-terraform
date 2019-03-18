resource "aws_subnet" "private_1" {
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.private_1", var.vpc["default.private_1"])}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${lookup(var.availability_zone, "${terraform.env}.az_1", var.availability_zone["default.az_1"])}"

  tags {
    Name = "${terraform.workspace}-private-1"
  }
}

resource "aws_subnet" "private_2" {
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.private_2", var.vpc["default.private_2"])}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${lookup(var.availability_zone, "${terraform.env}.az_2", var.availability_zone["default.az_2"])}"

  tags {
    Name = "${terraform.workspace}-private-2"
  }
}

resource "aws_subnet" "private_3" {
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.private_3", var.vpc["default.private_3"])}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${lookup(var.availability_zone, "${terraform.env}.az_3", var.availability_zone["default.az_3"])}"

  tags {
    Name = "${terraform.workspace}-private-3"
  }
}
