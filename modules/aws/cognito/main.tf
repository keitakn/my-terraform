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
    default_email_option  = "CONFIRM_WITH_LINK"
    email_message_by_link = "メールアドレスを検証するには、次のリンクをクリックしてください。 {##Verify Email##}"
    email_subject_by_link = "cognito 検証リンク"
    sms_message           = "検証コードは {####} です。"
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

resource "aws_cognito_user_pool_domain" "admin_user_nurse_senka" {
  domain       = "${terraform.workspace}-keitakn"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_identity_pool" "id_pool" {
  identity_pool_name               = "${terraform.workspace} keitakn IDPool"
  allow_unauthenticated_identities = false
}

resource "aws_iam_role" "authenticated" {
  name = "${terraform.workspace}-cognito-authenticated"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.id_pool.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "authenticated" {
  name = "${terraform.workspace}-authenticated-policy"
  role = aws_iam_role.authenticated.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "mobileanalytics:PutEvents",
        "cognito-sync:*",
        "cognito-identity:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_cognito_identity_pool_roles_attachment" "id_pool" {
  identity_pool_id = aws_cognito_identity_pool.id_pool.id

  roles = {
    "authenticated" = aws_iam_role.authenticated.arn
  }
}

// https://github.com/keitakn/next-idaas
resource "aws_cognito_user_pool_client" "next_idaas_client" {
  name                          = "${terraform.workspace}-next-idaas"
  user_pool_id                  = aws_cognito_user_pool.user_pool.id
  generate_secret               = false
  prevent_user_existence_errors = "ENABLED"
  refresh_token_validity        = 30
}
