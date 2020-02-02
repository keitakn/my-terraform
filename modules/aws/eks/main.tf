resource "aws_eks_cluster" "eks_cluster" {
  name     = "${terraform.workspace}-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    security_group_ids      = [aws_security_group.eks_master.id]
    endpoint_public_access  = true
    endpoint_private_access = true
    subnet_ids = [
      var.vpc["subnet_public_1"],
      var.vpc["subnet_public_2"],
      var.vpc["subnet_public_3"],
      var.vpc["subnet_private_1"],
      var.vpc["subnet_private_2"],
      var.vpc["subnet_private_3"],
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.attach_eks_cluster_policy,
    aws_iam_role_policy_attachment.attach_eks_service_policy,
  ]
}

resource "aws_eks_fargate_profile" "golang_grpc_client" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "${terraform.workspace}-golang-grpc-client"
  pod_execution_role_arn = aws_iam_role.eks_fargate_role.arn
  subnet_ids = [
    var.vpc["subnet_private_1"],
    var.vpc["subnet_private_2"],
    var.vpc["subnet_private_3"],
  ]
  selector {
    namespace = "golang-grpc-client"
  }
}
