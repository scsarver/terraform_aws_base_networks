variable "aws_tag_project" {
  type        = "string"
  description = "This is the tag applied to assets created representing the version controled project."
}

variable "aws_tag_project_path" {
  type        = "string"
  description = "This is the tag applied to assets created representing the version controled projects path used for namespacing different paths of a project."
}

variable "aws_tag_tool" {
  type        = "string"
  description = "This is the aws tag applied to assets created representing the tool used to create the assets."
}

variable "ENV_aws_region" {
  type        = "string"
  description = "The AWS region used to build the assets in."
}


variable "ENV_aws_account_1_name" {
  type        = "string"
  description = "The name to be used for the first account."
}

variable "ENV_aws_account_1_email_prefix" {
  type        = "string"
  description = "The email to be used for the first account(everything before the @ symbol)."
}

variable "ENV_aws_account_1_email_provider" {
  type        = "string"
  description = "The email provider to be used for the first account(everything after the @ symbol)."
}
