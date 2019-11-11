resource "aws_cognito_user_pool" "pool" {
  name = "mypool"
}

resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "identity pool"
  allow_unauthenticated_identities = false
}
