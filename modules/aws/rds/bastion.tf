resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = lookup(var.bastion, "${terraform.workspace}.name", var.bastion["default.name"])
  role = aws_iam_role.bastion_role.name
}

resource "aws_security_group" "bastion" {
  name = "${terraform.workspace}-${lookup(
    var.bastion,
    "${terraform.workspace}.name",
    var.bastion["default.name"],
  )}"
  description = "Security Group to ${lookup(
    var.bastion,
    "${terraform.workspace}.name",
    var.bastion["default.name"],
  )}"
  vpc_id = var.vpc["vpc_id"]

  tags = {
    Name = "${terraform.workspace}-${lookup(
      var.bastion,
      "${terraform.workspace}.name",
      var.bastion["default.name"],
    )}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami = lookup(
    var.bastion,
    "${terraform.workspace}.ami",
    var.bastion["default.ami"],
  )
  associate_public_ip_address = true
  instance_type = lookup(
    var.bastion,
    "${terraform.workspace}.instance_type",
    var.bastion["default.instance_type"],
  )

  iam_instance_profile = aws_iam_instance_profile.bastion_instance_profile.name

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = lookup(
      var.bastion,
      "${terraform.workspace}.volume_type",
      var.bastion["default.volume_type"],
    )
    volume_size = lookup(
      var.bastion,
      "${terraform.workspace}.volume_size",
      var.bastion["default.volume_size"],
    )
  }

  subnet_id              = var.vpc["subnet_public_3"]
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "${terraform.workspace}-${lookup(
      var.bastion,
      "${terraform.workspace}.name",
      var.bastion["default.name"],
    )}"
  }

  lifecycle {
    ignore_changes = all
  }
}
