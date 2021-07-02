variable "vpc_id" {
  type = string
}

variable "sg_ingress" {
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

variable "bucket_name" {
  type    = string
  default = null
}

variable "bucket_prefix" {
  type    = string
  default = null
}

variable "cluster_name" {
  type = string
}

variable "kafka_version" {
  type = string
}

variable "number_of_broker_nodes" {
  type = number
}

variable "instance_type" {
  type    = string
  default = "kafka.t3.small"
}

variable "ebs_volume_size" {
  type    = number
  default = 100
}

variable "tags" {
  type = map(string)
}

variable "client_subnets" {
  type = list(string)
}

variable "extra_security_groups" {
  type    = list(string)
  default = []
}

variable "open_monitoring" {
  type    = bool
  default = true
}

variable "enhanced_monitoring" {
  type    = string
  default = "DEFAULT"
}

variable "encryption_clientbroker" {
  type    = string
  default = "TLS"
}

variable "encryption_incluster" {
  type    = bool
  default = true
}

variable "configuration_info_arn" {
  type    = string
  default = null
}

variable "configuration_info_revision" {
  type    = string
  default = null
}

variable "default_configuration" {
  type    = list(string)
  default = []
}

variable "secrets_map" {
  type = map(map(string))
  default = {
    admin = {
      username = "admin",
      password = "xxxx"
    },
    sysops = {
      username = "sysops",
      password = "xxxx"
    }
  }
}

variable "extra_secrets_arn" {
  type    = list(string)
  default = []
}

variable "secrets_kms_key_id" {
  type    = string
  default = null
}
