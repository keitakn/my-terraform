resource "aws_subnet" "public_1" {
  cidr_block = lookup(
    var.vpc,
    "${terraform.workspace}.public_1",
    var.vpc["default.public_1"],
  )
  vpc_id = aws_vpc.vpc.id
  availability_zone = lookup(
    var.availability_zone,
    "${terraform.workspace}.az_1",
    var.availability_zone["default.az_1"],
  )

  tags = {
    Name = "${terraform.workspace}-public-1"
  }
}

resource "aws_subnet" "public_2" {
  cidr_block = lookup(
    var.vpc,
    "${terraform.workspace}.public_2",
    var.vpc["default.public_2"],
  )
  vpc_id = aws_vpc.vpc.id
  availability_zone = lookup(
    var.availability_zone,
    "${terraform.workspace}.az_2",
    var.availability_zone["default.az_2"],
  )

  tags = {
    Name = "${terraform.workspace}-public-2"
  }
}

resource "aws_subnet" "public_3" {
  cidr_block = lookup(
    var.vpc,
    "${terraform.workspace}.public_3",
    var.vpc["default.public_3"],
  )
  vpc_id = aws_vpc.vpc.id
  availability_zone = lookup(
    var.availability_zone,
    "${terraform.workspace}.az_3",
    var.availability_zone["default.az_3"],
  )

  tags = {
    Name = "${terraform.workspace}-public-3"
  }
}
