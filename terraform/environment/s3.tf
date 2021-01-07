resource "aws_s3_bucket" "kinesis_data_analytics" {
  bucket = var.name
  acl    = "private"
}
