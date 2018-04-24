resource "aws_vpc" "primary_zone" {
  assign_generated_ipv6_cidr_block = "False"
  cidr_block                       = "${var.ENV_aws_vpc_primary_zone_cidr}"
  enable_classiclink               = "False"
  enable_dns_hostnames             = "True"
  enable_dns_support               = "True"
  instance_tenancy                 = "default"

  tags {
    "Name"         = "primary-zone-vpc"
    "Project"      = "${var.aws_tag_project}"
    "Project-Path" = "${var.aws_tag_project_path}"
    "Tool"         = "${var.aws_tag_tool}"
    "Zone"         = "primary"
  }
}

resource "aws_internet_gateway" "primary_zone_internet_gateway" {
  vpc_id = "${aws_vpc.primary_zone.id}"

  tags {
    "Name"         = "primary-zone-internet-gateway"
    "Project"      = "${var.aws_tag_project}"
    "Project-Path" = "${var.aws_tag_project_path}"
    "Tool"         = "${var.aws_tag_tool}"
    "Zone"         = "primary"
  }
}
