resource "aws_route_table" "primary_zone_private_route_table" {
  vpc_id = "${aws_vpc.primary_zone.id}"

  tags {
    "Name"         = "prinamry-zone-private-route-table"
    "Project"      = "${var.aws_tag_project}"
    "Project-Path" = "${var.aws_tag_project_path}"
    "Tool"         = "${var.aws_tag_tool}"
  }
}

resource "aws_subnet" "primary_zone_primary_private_subnet" {
  availability_zone       = "${var.ENV_aws_vpc_primary_zone_availability_zones[0]}"
  cidr_block              = "${var.ENV_aws_vpc_primary_zone_private_subnet_cidrs[0]}"
  map_public_ip_on_launch = "False"
  vpc_id                  = "${aws_vpc.primary_zone.id}"

  tags {
    "Name"         = "primary-zone-primary-private-subnet"
    "Project"      = "${var.aws_tag_project}"
    "Project-Path" = "${var.aws_tag_project_path}"
    "Tool"         = "${var.aws_tag_tool}"
  }
}

resource "aws_route_table_association" "primary_zone_primary_private_subnet_route_table_assoc" {
  route_table_id = "${aws_route_table.primary_zone_private_route_table.id}"
  subnet_id      = "${aws_subnet.primary_zone_primary_private_subnet.id}"
}

resource "aws_subnet" "primary_zone_secondary_private_subnet" {
  availability_zone       = "${var.ENV_aws_vpc_primary_zone_availability_zones[1]}"
  cidr_block              = "${var.ENV_aws_vpc_primary_zone_private_subnet_cidrs[1]}"
  map_public_ip_on_launch = "False"
  vpc_id                  = "${aws_vpc.primary_zone.id}"

  tags {
    "Name"         = "primary-zone-secondary-private-subnet"
    "Project"      = "${var.aws_tag_project}"
    "Project-Path" = "${var.aws_tag_project_path}"
    "Tool"         = "${var.aws_tag_tool}"
  }
}

resource "aws_route_table_association" "primary_zone_secondary_private_subnet_route_table_assoc" {
  route_table_id = "${aws_route_table.primary_zone_private_route_table.id}"
  subnet_id      = "${aws_subnet.primary_zone_secondary_private_subnet.id}"
}
