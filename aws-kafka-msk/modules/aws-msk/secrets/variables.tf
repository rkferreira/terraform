variable "secret_suffix" {
  type = string
}

variable "secret_value" {
  type = map(string)
}

variable "kms_key_id" {
  type = string
}

variable "tags" {
  type = map(string)
}
