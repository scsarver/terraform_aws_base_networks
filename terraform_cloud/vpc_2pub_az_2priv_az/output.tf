output "primary_vpc_id" {
  description = "This is the AWS resource ID for the primary virtual private cloud(vpc)"
  value = "${aws_vpc.primary_zone.id}"
}

output "primary_vpc_cidr_block" {
  description = "This is the cidr block for the primary virtual private cloud(vpc) ip address range"
  value = "${aws_vpc.primary_zone.cidr_block}"
}

output "public_primary_subnet_id" {
  description = "This is the AWS resource ID for the primary virtual private clouds primary public subnet."
  value = "${aws_subnet.primary_zone_primary_public_subnet.id}"
v}

output "public_secondary_subnet_id" {
  description = "This is the AWS resource ID for the primary virtual private clouds secondary public subnet."
  value = "${aws_subnet.primary_zone_secondary_public_subnet.id}"
}

output "private_primary_subnet_id" {
  description = "This is the AWS resource ID for the primary virtual private clouds primary private subnet."
  value = "${aws_subnet.primary_zone_primary_private_subnet.id}"
}

output "private_secondary_subnet_id" {
  description = "This is the AWS resource ID for the primary virtual private clouds secondary private subnet."
  value = "${aws_subnet.primary_zone_secondary_private_subnet.id}"
}
