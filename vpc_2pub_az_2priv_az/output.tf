output "primary_vpc_id" {
  value = "${aws_vpc.primary_zone.id}"
}

output "primary_vpc_cidr_block" {
  value = "${aws_vpc.primary_zone.cidr_block}"
}
