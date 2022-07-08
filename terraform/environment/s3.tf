#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket" "kinesis_data_analytics" {
  bucket = var.name
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "kinesis_data_analytics" {
  bucket                  = aws_s3_bucket.kinesis_data_analytics.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kinesis_data_analytics" {
  bucket = aws_s3_bucket.kinesis_data_analytics.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_kinesis_data_analytics.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
