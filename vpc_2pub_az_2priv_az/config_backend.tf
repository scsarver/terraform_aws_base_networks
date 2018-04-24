terraform {
  required_version = "0.11.5"

  backend "s3" {
    key = "terraform_aws_base_networks/vpc_2pub_az_2priv_az/terraform.tfstate"
  }
}
