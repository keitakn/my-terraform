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
