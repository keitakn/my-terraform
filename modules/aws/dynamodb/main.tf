resource "aws_dynamodb_table" "authentication_tokens" {
  name           = lookup(var.authentication_tokens_table, "${terraform.workspace}.name", var.authentication_tokens_table["default.name"])
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "Token"

  attribute {
    name = "Token"
    type = "S"
  }

  attribute {
    name = "CognitoSub"
    type = "S"
  }

  ttl {
    attribute_name = "ExpirationTime"
    enabled        = true
  }

  global_secondary_index {
    name            = "AuthenticationTokensGlobalIndexCognitoSub"
    hash_key        = "CognitoSub"
    write_capacity  = 1
    read_capacity   = 1
    projection_type = "ALL"
  }

  tags = {
    Name        = lookup(var.authentication_tokens_table, "${terraform.workspace}.name", var.authentication_tokens_table["default.name"])
    Environment = terraform.workspace
  }
}
