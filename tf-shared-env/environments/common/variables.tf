#########################################
## Main
#

variable "vpc_data" {
  type = list(object({
    vpc_cidr           = string
    subnet_private_ids = list(string)
    subnet_public_ids  = list(string)
    subnet_db_ids      = list(string)
  }))
}

variable "vpc_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "ami" {
  type = map(any)
}

variable "net_internal" {
  type = list(any)
}

variable "tags" {
  type = map(any)
}

#########################################
## 
#
