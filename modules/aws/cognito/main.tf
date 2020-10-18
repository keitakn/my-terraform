resource "aws_cognito_user_pool" "user_pool" {
  name                     = "${terraform.workspace}-keitakn-user-pool"
  auto_verified_attributes = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  username_attributes = ["email", "phone_number"]

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  mfa_configuration = "OPTIONAL"

  software_token_mfa_configuration {
    enabled = true
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

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = "${terraform.workspace}-keitakn"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

// https://github.com/keitakn/next-idaas
resource "aws_cognito_user_pool_client" "next_idaas_spa_client" {
  name                          = "${terraform.workspace}-next-idaas-spa"
  user_pool_id                  = aws_cognito_user_pool.user_pool.id
  generate_secret               = false
  prevent_user_existence_errors = "ENABLED"
  refresh_token_validity        = 30
  explicit_auth_flows           = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  supported_identity_providers = ["COGNITO", "LINE", "Facebook"]

  callback_urls = sort([
    "http://localhost:3900/cognito/callback",
  ])

  logout_urls = sort([
    "http://localhost:3900/cognito/logout",
  ])

  allowed_oauth_flows_user_pool_client = true

  allowed_oauth_flows  = ["code"]
  allowed_oauth_scopes = ["openid", "phone", "email", "profile"]

  depends_on = [aws_cognito_identity_provider.line, aws_cognito_identity_provider.facebook]
}

resource "aws_cognito_identity_provider" "line" {
  user_pool_id  = aws_cognito_user_pool.user_pool.id
  provider_name = "LINE"
  provider_type = "OIDC"

  provider_details = {
    client_id                     = jsondecode(data.aws_secretsmanager_secret_version.next_idaas.secret_string)["LINE_CLIENT_ID"]
    client_secret                 = jsondecode(data.aws_secretsmanager_secret_version.next_idaas.secret_string)["LINE_CLIENT_SECRET"]
    attributes_request_method     = "GET"
    authorize_scopes              = "profile email openid"
    oidc_issuer                   = "https://access.line.me"
    authorize_url                 = "https://access.line.me/oauth2/v2.1/authorize"
    token_url                     = "https://api.line.me/oauth2/v2.1/token"
    attributes_url                = "https://api.line.me/v2/profile"
    attributes_url_add_attributes = false
    jwks_uri                      = "https://api.line.me/oauth2/v2.1/verify"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}

resource "aws_cognito_identity_provider" "facebook" {
  user_pool_id  = aws_cognito_user_pool.user_pool.id
  provider_name = "Facebook"
  provider_type = "Facebook"

  provider_details = {
    api_version                   = "v6.0"
    authorize_scopes              = "public_profile,email"
    client_id                     = jsondecode(data.aws_secretsmanager_secret_version.next_idaas.secret_string)["FACEBOOK_CLIENT_ID"]
    client_secret                 = jsondecode(data.aws_secretsmanager_secret_version.next_idaas.secret_string)["FACEBOOK_CLIENT_SECRET"]
    attributes_url                = "https://graph.facebook.com/v6.0/me?fields="
    attributes_url_add_attributes = true
    authorize_url                 = "https://www.facebook.com/v6.0/dialog/oauth"
    token_request_method          = "GET"
    token_url                     = "https://graph.facebook.com/v6.0/oauth/access_token"
  }

  attribute_mapping = {
    email    = "email"
    username = "id"
  }
}

resource "aws_cognito_resource_server" "cognito_admin_api" {
  identifier = "${terraform.workspace}-cognito-admin-api"
  name       = "${terraform.workspace}-cognito-admin-api"

  scope {
    scope_description = "go-cognito-lambdaに実装されているcognitoの管理者用APIの利用権限"
    scope_name        = "admin"
  }

  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_user_pool_client" "next_idaas_server_client" {
  name                          = "${terraform.workspace}-next-idaas-server"
  user_pool_id                  = aws_cognito_user_pool.user_pool.id
  generate_secret               = true
  prevent_user_existence_errors = "ENABLED"

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_scopes                 = ["${aws_cognito_resource_server.cognito_admin_api.name}/admin"]

  depends_on = [aws_cognito_resource_server.cognito_admin_api]
}
