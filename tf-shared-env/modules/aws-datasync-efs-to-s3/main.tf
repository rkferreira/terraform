data "aws_efs_file_system" "source_efs_id" {
  file_system_id = var.efs_id
}

data "aws_subnet" "source_efs_subnet" {
  count = length(var.subnet_ids)
  id    = var.subnet_ids[count.index]
}

data "aws_security_group" "source_efs_sg" {
  count = length(var.sg_id)
  id    = var.sg_id[count.index]
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_datasync_location_efs" "datasync-efs" {
  efs_file_system_arn = data.aws_efs_file_system.source_efs_id.arn
  subdirectory        = var.efsdir

  ec2_config {
    security_group_arns = tolist(data.aws_security_group.source_efs_sg[*].arn)
    subnet_arn          = data.aws_subnet.source_efs_subnet[0].arn
  }
}

resource "aws_iam_role" "datasync-s3-role" {
  name = "gb-DataSyncS3BucketAccess-${var.bucket_name}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        "Action" : "sts:AssumeRole"
        "Effect" : "Allow"
        "Principal" : {
          "Service" : "datasync.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "gb-DataSyncS3BucketAccess-${var.bucket_name}"
    policy = jsonencode({
      "Version" : "2012-10-17"
      "Statement" : [
        {
          "Action" : [
            "s3:GetBucketLocation",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads"
          ],
          "Effect" : "Allow"
          "Resource" : "${aws_s3_bucket.s3_bucket.arn}"
        },
        {
          "Action" : [
            "s3:AbortMultipartUpload",
            "s3:DeleteObject",
            "s3:GetObject",
            "s3:ListMultipartUploadParts",
            "s3:PutObjectTagging",
            "s3:GetObjectTagging",
            "s3:PutObject"
          ],
          "Effect" : "Allow"
          "Resource" : "${aws_s3_bucket.s3_bucket.arn}/*"
        },
      ]
    })
  }
}

resource "aws_datasync_location_s3" "datasync-s3" {
  s3_bucket_arn = aws_s3_bucket.s3_bucket.arn
  subdirectory  = var.s3dir

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync-s3-role.arn
  }
}

resource "aws_datasync_task" "datasync_task" {
  destination_location_arn = aws_datasync_location_s3.datasync-s3.arn
  name                     = var.dsync_name
  source_location_arn      = aws_datasync_location_efs.datasync-efs.arn

  options {
    bytes_per_second = -1
  }
}

