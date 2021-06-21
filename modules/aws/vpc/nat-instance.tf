resource "aws_security_group" "nat_instance" {
  name = lookup(
    var.nat_instance,
    "${terraform.workspace}.name",
    var.nat_instance["default.name"],
  )
  description = lookup(
    var.nat_instance,
    "${terraform.workspace}.name",
    var.nat_instance["default.name"],
  )
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = lookup(
      var.nat_instance,
      "${terraform.workspace}.name",
      var.nat_instance["default.name"],
    )
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "http_from_vpc_to_nat_instance" {
  security_group_id = aws_security_group.nat_instance.id
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "https_from_vpc_to_nat_instance" {
  security_group_id = aws_security_group.nat_instance.id
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
}

data "aws_iam_policy_document" "nat_instance_trust_relationship" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "nat_instance_role" {
  name               = "${terraform.workspace}-nat-instance-default-role"
  assume_role_policy = data.aws_iam_policy_document.nat_instance_trust_relationship.json
}

resource "aws_iam_role_policy_attachment" "attachment_amazon_ec2_role_for_ssm" {
  role       = aws_iam_role.nat_instance_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "nat_instance_policy" {
  statement {
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "ec2:DescribeTags",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "nat_instance_role_policy" {
  name   = "${terraform.workspace}-nat-instance-role-policy"
  role   = aws_iam_role.nat_instance_role.id
  policy = data.aws_iam_policy_document.nat_instance_policy.json
}

resource "aws_iam_instance_profile" "nat_instance_profile" {
  name = "${terraform.workspace}-nat-instance-profile"
  role = aws_iam_role.nat_instance_role.name
}

resource "aws_instance" "nat_instance" {
  ami = lookup(
    var.nat_instance,
    "${terraform.workspace}.ami",
    var.nat_instance["default.ami"],
  )
  associate_public_ip_address = true
  instance_type = lookup(
    var.nat_instance,
    "${terraform.workspace}.instance_type",
    var.nat_instance["default.instance_type"],
  )

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = lookup(
      var.nat_instance,
      "${terraform.workspace}.volume_type",
      var.nat_instance["default.volume_type"],
    )
    volume_size = lookup(
      var.nat_instance,
      "${terraform.workspace}.volume_size",
      var.nat_instance["default.volume_size"],
    )
  }

  subnet_id              = aws_subnet.public_3.id
  vpc_security_group_ids = [aws_security_group.nat_instance.id]

  tags = {
    "Name" = "${terraform.workspace}-nat-instance-3"
  }

  iam_instance_profile = aws_iam_instance_profile.nat_instance_profile.name
  monitoring           = true
  source_dest_check    = false

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_route_table" "nat_instance_private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat_instance.id
  }

  tags = {
    Name = "${lookup(
      var.nat_instance,
      "${terraform.workspace}.name",
      var.nat_instance["default.name"],
    )}-private-rt"
  }
}

resource "aws_route_table_association" "nat_instance_private_1" {
  route_table_id = aws_route_table.nat_instance_private.id
  subnet_id      = aws_subnet.private_1.id
}

resource "aws_route_table_association" "nat_instance_private_2" {
  route_table_id = aws_route_table.nat_instance_private.id
  subnet_id      = aws_subnet.private_2.id
}

resource "aws_route_table_association" "nat_instance_private_3" {
  route_table_id = aws_route_table.nat_instance_private.id
  subnet_id      = aws_subnet.private_3.id
}
