resource "aws_route_table" "primary_zone_public_route_table" {
  vpc_id = "${aws_vpc.primary_zone.id}"

  tags {
    "Name"                = "prinamry-zone-public-route-table"
    "Project"             = "${var.aws_tag_project}"
    "Project-Path"        = "${var.aws_tag_project_path}"
    "Tool"                = "${var.aws_tag_tool}"
  }
}

resource "aws_subnet" "primary_zone_primary_public_subnet" {
  availability_zone       = "${var.ENV_aws_vpc_primary_zone_availability_zones[0]}"
  cidr_block              = "${var.ENV_aws_vpc_primary_zone_public_subnet_cidrs[0]}"
  map_public_ip_on_launch = "True"
  vpc_id = "${aws_vpc.primary_zone.id}"
  tags {
    "Name"                = "primary-zone-primary-public-subnet"
    "Project"             = "${var.aws_tag_project}"
    "Project-Path"        = "${var.aws_tag_project_path}"
    "Tool"                = "${var.aws_tag_tool}"
  }
}

resource "aws_route_table_association" "primary_zone_primary_public_subnet_route_table_assoc" {
  route_table_id = "${aws_route_table.primary_zone_public_route_table.id}"
  subnet_id      = "${aws_subnet.primary_zone_primary_public_subnet.id}"
}

resource "aws_subnet" "primary_zone_secondary_public_subnet" {
  availability_zone       = "${var.ENV_aws_vpc_primary_zone_availability_zones[1]}"
  cidr_block              = "${var.ENV_aws_vpc_primary_zone_public_subnet_cidrs[1]}"
  map_public_ip_on_launch = "True"
  vpc_id                  = "${aws_vpc.primary_zone.id}"

  tags {
    "Name"                = "primary-zone-secondary-public-subnet"
    "Project"             = "${var.aws_tag_project}"
    "Project-Path"        = "${var.aws_tag_project_path}"
    "Tool"                = "${var.aws_tag_tool}"
  }
}

resource "aws_route_table_association" "primary_zone_secondary_public_subnet_route_table_assoc" {
  route_table_id = "${aws_route_table.primary_zone_public_route_table.id}"
  subnet_id      = "${aws_subnet.primary_zone_secondary_public_subnet.id}"
}


resource "aws_eip" "primary_zone_eip_public_nat" {
  vpc = true
}

resource "aws_nat_gateway" "primary_zone_public_nat_gateway" {
  allocation_id = "${aws_eip.primary_zone_eip_public_nat.id}"
  subnet_id     = "${aws_subnet.primary_zone_primary_public_subnet.id}"
}

resource "aws_route" "primary_zone_public_internet_gateway_route" {
  destination_cidr_block = "${var.cidr_external_access}"
  gateway_id             = "${aws_internet_gateway.primary_zone_internet_gateway.id}"
  route_table_id         = "${aws_route_table.primary_zone_public_route_table.id}"
}
