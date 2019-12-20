resource "aws_s3_bucket" "scsresearch-scp-test" {
  bucket = "scsresearch-scp-bucket-test"
  acl    = "private"

  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm     = "AES256"
  #     }
  #   }
  # }
}

resource "aws_s3_bucket_object" "scsresearch-scp-test" {
  key                    = "scsresearch-scp-bucket-test"
  bucket                 = "${aws_s3_bucket.scsresearch-scp-test.id}"
  content                 = "This super secret text shall only be uploaded to s3 as an object if the serverside encryption is set otherwise SCP should reject it."
  server_side_encryption = "AES256"
}
