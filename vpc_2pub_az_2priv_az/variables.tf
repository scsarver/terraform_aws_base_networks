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

variable "cidr_external_access" {
  type        = "string"
  description = "The value of a a external access cidr block."
}

variable "ENV_aws_region"  {
  type        = "string"
  description = "The AWS region used to build the assets in."
}

variable "ENV_aws_vpc_primary_zone_cidr" {
  type        = "string"
  description = "The primary_zone vpc cidr block."
}

variable "ENV_aws_vpc_primary_zone_availability_zones" {
  type        = "list"
  description = "The primary_zone availability zones."
}

variable "ENV_aws_vpc_primary_zone_public_subnet_cidrs" {
  type        = "list"
  description = "The primary_zone public subnet cidr blocks"
}

variable "ENV_aws_vpc_primary_zone_private_subnet_cidrs" {
  type        = "list"
  description = "The primary_zone private subnet cidr blocks"
}
