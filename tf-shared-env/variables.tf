###
## Main
#
variable "aws_account_id" {
  description = "Mandatory - Defines AWS account id of the environment"
  type        = string
}

variable "aws_region" {
  description = "Mandatory - Define AWS region"
  type        = string
}

variable "aws_role" {
  description = "Mandatory - Define AWS role"
  type        = string
}

variable "environment" {
  description = "Mandatory - Defines the target environment and AWS account"
  type        = string
}

variable "vs" {
  description = "Tagging"
  type        = string
  default     = "demanda-e-abastecimento"
}

variable "squad" {
  description = "Tagging"
  type        = string
  default     = "go"
}

variable "product" {
  description = "Tagging"
  type        = string
  default     = "go"
}

variable "application" {
  description = "Tagging"
  type        = string
  default     = "go"
}

variable "tier" {
  description = "Tagging"
  type        = string
  default     = "backend"
}

###
##
#

variable "vpc_id" {
  description = "AWS account vpc id"
  type        = string
}

variable "key_name" {
  description = "EC2 key"
  type        = string
  default     = "default-key"
}

variable "network_internals" {
  description = "RFC1918 addresses"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12"]
}

variable "ami-us" {
  description = "AMI ids for systems on us-east-1"
  type        = map(any)
  default = {
    suse-sles-15-sp1  = "ami-0965b4"
    suse-sles-15-sp2  = "ami-0a782e"
  }
}

variable "ami-br" {
  description = "AMI ids for systems on br"
  type        = map(any)
  default = {
    suse-sles-15-sp1  = "ami-0965ba"
    suse-sles-15-sp2  = "ami-0a782e"
  }
}
