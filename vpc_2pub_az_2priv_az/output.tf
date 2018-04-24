output "primary_vpc_id" {
  value = "${aws_vpc.primary_zone.id}"
}

output "primary_vpc_cidr_block" {
  value = "${aws_vpc.primary_zone.cidr_block}"
}

output "public_primary_subnet_id" {
  value = "${aws_subnet.primary_zone_primary_public_subnet.id}"
}

output "public_secondary_subnet_id" {
  value = "${aws_subnet.primary_zone_secondary_public_subnet.id}"
}

output "private_primary_subnet_id" {
  value = "${aws_subnet.primary_zone_primary_private_subnet.id}"
}

output "private_secondary_subnet_id" {
  value = "${aws_subnet.primary_zone_secondary_private_subnet.id}"
}
