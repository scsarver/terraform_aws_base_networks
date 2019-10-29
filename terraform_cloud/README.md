


Terraform Cloud Notes:
- Need to create your TF Cloud account: https://app.terraform.io
- Need to create a workspace and point to your VCS code base where your terraform config lives (you will need to authenticate to Github for example).
- Need to add your cloud provider credentials to the workspace so TF Cloud can run plan and apply's to your account.
- Need to create a user token and create your ~/.terraformrc file so your cli can run plans and apply's from your TF Cloud account.
- Need to run terraform init --backend-config=./backend.conf so your state will be managed by Terraform cloud Note: your file can be named differently however this repo .gitignored backend.conf files so they wont be checked in to version control.



Code upgrade Notes (this is completed for in this directory but not an exhaustive list of required changes):
- terraform validate caught the following items when using version 0.12 from 0.11.x
  - The tags property for aws objects needed to be assigned with the "=" sign.
  - The names of tags for aws objects could not be quoted.
  - Boolean properties must not be defined as Strings

References:
- Getting started: https://learn.hashicorp.com/terraform/cloud/tf_cloud_gettingstarted.html
- Video for setting up Terraform Cloud: https://www.youtube.com/watch?v=l3ZbEO0z7z8
- Note on variable files and '*.auto.tfvars': https://www.terraform.io/docs/cloud/workspaces/variables.html
