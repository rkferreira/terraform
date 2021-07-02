module "backup" {
  source = "../../modules/aws-backup"

  vault_name         = "daily-backup"
  create_vault       = true
  plan_rule_name     = "diario"
  plan_rule_schedule = "cron(0 4 * * ? *)"
  start_window       = 120
  completion_window  = 240
  cold_storage_after = 30
  delete_after       = 120
  selection_tags = [
    { type = "STRINGEQUALS", key = "backup", value = "daily" }
  ]

  tags = var.tags
}

module "backup-windows-diario" {
  source = "../../modules/aws-backup"

  vault_name         = module.backup.vault_name
  create_vault       = false
  plan_name          = "${module.backup.vault_name}-daily-win"
  selection_name     = "${module.backup.vault_name}-daily-win"
  selection_iam      = module.backup.vault_iam-role
  plan_rule_name     = "daily-win"
  plan_rule_schedule = "cron(0 4 * * ? *)"
  start_window       = 120
  completion_window  = 240
  cold_storage_after = 30
  delete_after       = 120
  advanced_backup_setting = {
    WindowsVSS    = "enabled"
    resource_type = "EC2"
  }
  selection_tags = [
    { type = "STRINGEQUALS", key = "backup", value = "daily-win" }
  ]
  depends_on = [ module.backup ]
  tags = var.tags
}
