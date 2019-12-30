resource "aws_db_instance" "scsresearch-scp-test" {
  allocated_storage = 10
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  name              = "mydb"
  username          = "scsresearch-scp-test"
  password          = "${var.ENV_rds_pass}"

  # SCP should fail to allow this resource to be created when storage_encrypted is false!
  storage_encrypted = false
}
