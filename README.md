# AWS Terraform

## Plan and Update terraform

Remember to unlock the encrypted files.

terraform plan -var-file=../secrets/env.tfvars
terraform apply -var-file=../secrets/env.tfvars
terraform deploy -var-file=../secrets/env.tfvars
