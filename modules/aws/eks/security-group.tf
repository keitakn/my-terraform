resource "aws_security_group" "eks_master" {
  name        = "${terraform.workspace}-eks-master"
  description = "EKS master Security Group"
  vpc_id      = var.vpc["vpc_id"]

  tags = {
    Name = "${terraform.workspace}-eks-master"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

