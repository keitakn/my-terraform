variable "authentication_tokens_table" {
  type = map(string)

  default = {
    "default.name" = "ProdAuthenticationTokens"
    "stg.name"     = "StgAuthenticationTokens"
    "dev.name"     = "DevAuthenticationTokens"
    "qa.name"      = "QaAuthenticationTokens"
  }
}
