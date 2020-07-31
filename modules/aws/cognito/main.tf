resource "aws_cognito_user_pool" "pool" {
  name                     = "${terraform.workspace}-keitakn"
  auto_verified_attributes = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_message        = "検証コードは {####} です。"
    email_subject        = "検証コード"
    sms_message          = "検証コードは {####} です。"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  email_configuration {
    source_arn            = var.ses["email_identity_arn"]
    email_sending_account = "DEVELOPER"
  }
}

// https://github.com/keitakn/next-idaas
resource "aws_cognito_user_pool_client" "next_idaas_client" {
  name                          = "${terraform.workspace}-next-idaas"
  user_pool_id                  = aws_cognito_user_pool.pool.id
  generate_secret               = false
  prevent_user_existence_errors = "ENABLED"
  refresh_token_validity        = 30
  explicit_auth_flows           = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}
