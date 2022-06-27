resource "aws_s3_bucket" "kinesis_data_analytics" {
  bucket = var.name
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "kinesis_data_analytics" {
  bucket              = aws_s3_bucket.kinesis_data_analytics.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}
