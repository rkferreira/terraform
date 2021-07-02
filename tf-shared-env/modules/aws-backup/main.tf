resource "aws_backup_vault" "vault" {
  count       = var.create_vault == true ? 1 : 0
  name        = var.vault_name
  kms_key_arn = var.kms_key_arn != null ? var.kms_key_arn : null
  tags        = var.tags
}


resource "aws_backup_plan" "backup_plan" {
  count = var.create_plan == true ? 1 : 0
  name = var.plan_name != null ? var.plan_name : "${var.vault_name}-default-plan"

  rule {
    rule_name         = var.plan_rule_name
    target_vault_name = var.vault_name
    schedule          = var.plan_rule_schedule
    start_window      = var.start_window
    completion_window = var.completion_window

    dynamic "lifecycle" {
      for_each = var.cold_storage_after != null || var.delete_after != null ? ["true"] : []
      content {
        cold_storage_after = var.cold_storage_after
        delete_after       = var.delete_after
      }
    }

    dynamic "copy_action" {
      for_each = var.destination_vault_arn != null ? ["true"] : []
      content {
        destination_vault_arn = var.destination_vault_arn

        dynamic "lifecycle" {
          for_each = var.copy_cold_storage_after != null || var.copy_delete_after != null ? ["true"] : []
          content {
            cold_storage_after = var.copy_cold_storage_after
            delete_after       = var.copy_delete_after
          }
        }
      }
    }
  }

  dynamic "advanced_backup_setting" {
    for_each = var.advanced_backup_setting != null ? ["true"] : []
    content {
      resource_type  = var.advanced_backup_setting["resource_type"]
      backup_options = {
        WindowsVSS = var.advanced_backup_setting["WindowsVSS"]
      }
    }
  }

  tags = var.tags
}

resource "aws_iam_role" "vault" {
  count       = var.create_vault == true ? 1 : 0
  name               = "vault-role-${var.vault_name}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "vault" {
  count       = var.create_vault == true ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.vault[0].name
}

resource "aws_backup_selection" "backup_selection" {
  name         = var.selection_name != null ? var.selection_name : "${var.vault_name}-default-selection"
  iam_role_arn = var.selection_iam != null ? var.selection_iam : aws_iam_role.vault[0].arn
  plan_id      = var.selection_planid != null ? var.selection_planid : aws_backup_plan.backup_plan[0].id

  dynamic "selection_tag" {
    for_each = var.selection_tags
    content {
      type  = selection_tag.value["type"]
      key   = selection_tag.value["key"]
      value = selection_tag.value["value"]
    }
  }
}
