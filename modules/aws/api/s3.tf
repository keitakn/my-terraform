resource "aws_s3_bucket" "rest_api_alb_logs" {
  bucket        = lookup(var.go_rest_api, "${terraform.workspace}.logs_bucket", var.go_rest_api["default.logs_bucket"])
  force_destroy = true
}

data "aws_iam_policy_document" "put_rest_api_alb_logs_policy" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.rest_api_alb_logs.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.aws_elb_service_account.id]
    }
  }
}

resource "aws_s3_bucket_policy" "rest_api" {
  bucket = aws_s3_bucket.rest_api_alb_logs.id
  policy = data.aws_iam_policy_document.put_rest_api_alb_logs_policy.json
}

resource "aws_s3_bucket" "graphql_alb_logs" {
  bucket        = lookup(var.go_graphql, "${terraform.workspace}.logs_bucket", var.go_graphql["default.logs_bucket"])
  force_destroy = true
}

data "aws_iam_policy_document" "put_graphql_alb_logs_policy" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.graphql_alb_logs.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.aws_elb_service_account.id]
    }
  }
}

resource "aws_s3_bucket_policy" "graphql" {
  bucket = aws_s3_bucket.graphql_alb_logs.id
  policy = data.aws_iam_policy_document.put_graphql_alb_logs_policy.json
}
