##############################################################
# Provider                                                   #
##############################################################
provider "aws" {
  region = var.AWS_DEFAULT_REGION
}

provider "aws" {
  alias  = "shared_account"
  region = var.AWS_DEFAULT_REGION
  assume_role {
    role_arn     = "arn:aws:iam::123:role/TfRole"
    session_name = "tf-dev"
    external_id  = "Terraform"
  }
}
data "terraform_remote_state" "infracore" {
  backend = "remote"

  config = {
    hostname     = "app.terraform.io"
    organization = "xxx"

    workspaces = {
      name = var.WRKINFRA
    }
  }
}
