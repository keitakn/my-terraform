data "aws_iam_policy_document" "eks_cluster_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "eks.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "${terraform.workspace}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "attach_eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role" "eks_fargate_role" {
  name = "${terraform.workspace}-eks-fargate-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "attach_eks_pod_execution_role" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks_fargate_role.name
}

data "aws_iam_policy_document" "alb_ingress_controller_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "acm.amazonaws.com",
        "elasticloadbalancing.amazonaws.com",
        "iam.amazonaws.com",
        "cognito-idp.amazonaws.com",
        "waf-regional.amazonaws.com",
        "waf.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "alb_ingress_controller_role" {
  name               = "${terraform.workspace}-alb-ingress-role"
  assume_role_policy = data.aws_iam_policy_document.alb_ingress_controller_trust_relationship.json
}

// 以下を参考にした
// https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/iam-policy.json
resource "aws_iam_role_policy" "alb_ingress_controller_role_policy" {
  name = "${terraform.workspace}-alb-ingress-role-policy"
  role = aws_iam_role.alb_ingress_controller_role.id
  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = [
          "acm:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "iam:*",
          "cognito-idp:DescribeUserPoolClient",
          "waf-regional:*",
          "tag:*",
          "waf:GetWebACL"
        ]
        Resource : "*"
      },
    ]
  })
}
