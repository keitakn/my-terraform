output "vpc" {
  value = "${
    map(
      "vpc_id", "${aws_vpc.vpc.id}",
      "nat_ip_1", "${aws_eip.nat_ip_1.public_ip}",
      "nat_ip_2", "${aws_eip.nat_ip_2.public_ip}",
      "nat_ip_3", "${aws_eip.nat_ip_3.public_ip}",
      "subnet_public_1", "${aws_subnet.public_1.id}",
      "subnet_public_2", "${aws_subnet.public_2.id}",
      "subnet_public_3", "${aws_subnet.public_3.id}",
      "subnet_private_1", "${aws_subnet.private_1.id}",
      "subnet_private_2", "${aws_subnet.private_2.id}",
      "subnet_private_3", "${aws_subnet.private_3.id}",
      "cidr_block_public_1", "${lookup(var.vpc, "${terraform.env}.public_1", var.vpc["default.public_1"])}",
      "cidr_block_public_2", "${lookup(var.vpc, "${terraform.env}.public_2", var.vpc["default.public_2"])}",
      "cidr_block_public_3", "${lookup(var.vpc, "${terraform.env}.public_3", var.vpc["default.public_3"])}",
      "cidr_block_private_1", "${lookup(var.vpc, "${terraform.env}.private_1", var.vpc["default.private_1"])}",
      "cidr_block_private_2", "${lookup(var.vpc, "${terraform.env}.private_2", var.vpc["default.private_2"])}",
      "cidr_block_private_3", "${lookup(var.vpc, "${terraform.env}.private_3", var.vpc["default.private_3"])}"
    )
  }"
}
