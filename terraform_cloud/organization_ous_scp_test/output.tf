output "purpose" {
  description = "Output describing the purpose of this terraform configuration."
  value = "This demos the attempt to create cloud resources against an account that is governed by a service control policy."
}

output "scsresearch-scp-test-bucket-name" {
  description = "The name of the scp testing bucket."
  value = "${aws_s3_bucket.scsresearch-scp-test.name}"
}
