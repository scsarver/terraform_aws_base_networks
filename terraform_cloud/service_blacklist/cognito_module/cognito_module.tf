resource "aws_cognito_user_pool" "cognito_module_user_pool" {
  name = "cognito_module_pool"
}

resource "aws_cognito_identity_pool" "cognito_module_main" {
  identity_pool_name               = "cognito module identity pool"
  allow_unauthenticated_identities = false
}
