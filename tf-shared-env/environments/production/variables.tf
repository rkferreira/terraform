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

#########################################
## 
#
