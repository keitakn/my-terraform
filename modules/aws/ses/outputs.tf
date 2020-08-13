output "ses" {
  value = {
    "email_identity_arn" = aws_ses_email_identity.from_email.arn
  }
}
