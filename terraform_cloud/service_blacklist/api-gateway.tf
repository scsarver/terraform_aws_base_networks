resource "aws_api_gateway_rest_api" "example" {
  name = "regional-example"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


# How can I add a blacklisted datasource resource type with out actually creating the resource first?
# data "aws_api_gateway_rest_api" "my_rest_api" {
#   name = "my-rest-api"
# }
