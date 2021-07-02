provider "aws" {
  region              = var.aws_region
  allowed_account_ids = ["${var.aws_account_id}"]
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_role}"
    session_name = "${var.environment}-${var.aws_account_id}-${var.aws_region}"
  }
}

terraform {
  required_version = "~> 1.0.0"
  backend "s3" {
    bucket  = "shared-tfstate"
    key     = "us-east-1/shared/terraform.state"
    region  = "us-east-1"
    encrypt = "true"
    profile = "shared"
  }
}
