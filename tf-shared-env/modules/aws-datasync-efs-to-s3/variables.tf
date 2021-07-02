variable "bucket_name" {
  type = string
}

variable "dsync_name" {
  type = string
}

variable "efs_id" {
  type = string
}

variable "s3dir" {
  type    = string
  default = "/"
}

variable "efsdir" {
  type    = string
  default = "/"
}

variable "subnet_ids" {
  type = list(string)
}

variable "sg_id" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
