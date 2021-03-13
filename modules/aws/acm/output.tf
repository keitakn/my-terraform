output "acm" {
  value = {
    "acm_certificate_arn" = data.aws_acm_certificate.main.arn
  }
}
