variable "create_vault" {
  type    = bool
  default = true
}
variable "create_plan" {
  type = bool
  default = true
}
variable "vault_name" {
  type = string
}
variable "kms_key_arn" {
  type    = string
  default = null
}

variable "tags" {
  type = map(string)
}

variable "plan_rule_name" {
  type = string
}

variable "plan_rule_schedule" {
  type    = string
  default = "cron(5 8 * * ? *)"
}

variable "start_window" {
  type = number
}

variable "completion_window" {
  type = number
}

variable "cold_storage_after" {
  type = number
}

variable "delete_after" {
  type = number
}
variable "destination_vault_arn" {
  type    = string
  default = null
}
variable "copy_cold_storage_after" {
  type = number
  default = null
}
variable "copy_delete_after" {
  type = number
  default = null
}
variable "selection_tags" {
  type = list(object({
    type  = string
    key   = string
    value = string
  }))
  default = []
}

variable "advanced_backup_setting" {
  type    = map(string)
  default = null
}

variable "selection_name" {
  type = string
  default = null
}

variable "selection_iam" {
  type = string
  default = null
}

variable "selection_planid" {
  type = string
  default = null
}

variable "plan_name" {
  type = string
  default = null
}
