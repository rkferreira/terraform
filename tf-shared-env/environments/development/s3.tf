locals {
  private_s3_ids = [aws_s3_bucket.default.id]
}

resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  for_each = toset(local.private_s3_ids)
  bucket   = each.key

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}


resource "aws_s3_bucket" "default" {
  bucket = "my-bucket"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "My-Bucket"
    Environment = "development"
  }
}
