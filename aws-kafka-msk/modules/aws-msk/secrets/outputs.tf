output "kafka_secret-id" {
  value = aws_secretsmanager_secret.msk_secrets.id
}

output "kafka_secret-arn" {
  value = aws_secretsmanager_secret.msk_secrets.arn
}

output "kafka_secret-version" {
  value = aws_secretsmanager_secret_version.msk_secrets.version_id
}
