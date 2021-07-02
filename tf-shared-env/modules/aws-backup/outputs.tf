output "vault_name" {
  value = join("", aws_backup_vault.vault.*.id)
}

output "vault_arn" {
  value = join("", aws_backup_vault.vault.*.arn)
}

output "plan_id" {
  value = join("", aws_backup_plan.backup_plan.*.id)
}

output "vault_iam-role" {
  value = join("", aws_iam_role.vault.*.arn)
}
