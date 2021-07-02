output "s3_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

output "s3_id" {
  value = aws_s3_bucket.s3_bucket.id
}

output "datasync_arn" {
  value = aws_datasync_task.datasync_task.arn
}

output "datasync_id" {
  value = aws_datasync_task.datasync_task.id
}
