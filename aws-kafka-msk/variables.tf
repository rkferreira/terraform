################################################################################
# AWS
variable "AWS_DEFAULT_REGION" {
  type        = string
  description = "AWS region in wich resources shall be created"
  default     = "us-east-1"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "AWS access key"
}

variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "AWS access key ID"
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

################################################################################
# Tags
################################################################################
variable "environment" {
  type        = string
  description = "Environment name to be appended on resources"
}

variable "vs" {
  type    = string
  default = "go"
}

variable "squad" {
  type    = string
  default = "go"
}

variable "product" {
  type    = string
  default = "msk"
}

variable "app" {
  type    = string
  default = "kafka"
}

variable "tier" {
  type    = string
  default = "backend"
}
################################################################################
# Variables - Frontend
################################################################################

variable "WRKINFRA" {
  description = "Workspace Infra"
  type        = string
  default     = "aws-dev-infra"
}

################################################################################
# MSK KAFKA
################################################################################

variable "msk_instance_type" {
  type    = string
  default = "kafka.t3.small"
}

variable "msk_ebs_volume_size" {
  type    = number
  default = "10"
}

variable "msk_s3_bucket" {
  type    = string
  default = null
}

variable "msk_cluster_name" {
  type    = string
  default = "my-kafka-cluster"
}

variable "msk_version" {
  type    = string
  default = "2.6.1"
}

variable "msk_number_brokers" {
  type    = number
  default = null
}

variable "msk_enhanced_monitoring" {
  type    = string
  default = "DEFAULT"
}

variable "msk_extra_sgs" {
  type    = list(string)
  default = []
}

variable "msk_default_configuration" {
  type    = list(string)
  default = []
}

variable "msk_sg_ingress" {
  description = "Security Group"
  type = list(object({
    from_port   = string
    to_port     = string
    protocol    = string
    description = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "msk_default_secrets_map" {
  type = map(map(string))
  default = {
    admin = {
      username = "admin",
      password = "4dm1n#"
    },
    sysops = {
      username = "sysops",
      password = "2y20p2%"
    }
  }
}

variable "msk_extra_secrets_arn" {
  type    = list(string)
  default = []
}
