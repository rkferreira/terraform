resource "aws_secretsmanager_secret" "msk_secrets" {
  name       = "AmazonMSK_${var.secret_suffix}"
  kms_key_id = var.kms_key_id
  policy     = <<POLICY
  {
    "Version" : "2012-10-17",
    "Statement" : [ {
      "Sid": "AWSKafkaResourcePolicy",
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "kafka.amazonaws.com"
      },
      "Action" : "secretsmanager:getSecretValue",
      "Resource" : "*"
    } ]
  }
  POLICY

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "msk_secrets" {
  secret_id     = aws_secretsmanager_secret.msk_secrets.id
  secret_string = jsonencode(var.secret_value)
}
