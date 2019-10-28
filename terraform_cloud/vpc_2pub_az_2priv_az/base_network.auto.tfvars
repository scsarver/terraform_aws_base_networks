aws_tag_tool = "terraform"
aws_tag_project = "terraform_aws_base_networks"
aws_tag_project_path = "terraform_cloud/vpc_2pub_az_2priv_az"
cidr_external_access = "0.0.0.0/0"
#
#
#The following ENV prefixed variables will be moved to an environment specific file.
ENV_aws_region = "us-east-1"
ENV_aws_vpc_primary_zone_cidr = "10.10.0.0/16"
ENV_aws_vpc_primary_zone_availability_zones = ["us-east-1b", "us-east-1c"]
ENV_aws_vpc_primary_zone_public_subnet_cidrs  = ["10.10.10.0/24", "10.10.11.0/24"]
ENV_aws_vpc_primary_zone_private_subnet_cidrs  = ["10.10.100.0/24", "10.10.101.0/24"]
