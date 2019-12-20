output "purpose" {
  description = "Output describing the purpose of this terraform configuration."
  value = "This demos the attempt to create cloud resources against an account that is governed by a service control policy."
}

output "scsresearch-scp-test-bucket-name" {
  description = "The name of the scp testing bucket."
  value = "${aws_s3_bucket.scsresearch-scp-test.name}"
}

output "scsresearch-scp-test-s3-object-key" {
  description = "The key of the object to put in the scp testing bucket."
  value = "${aws_s3_bucket_object.scsresearch-scp-test.key}"
}
