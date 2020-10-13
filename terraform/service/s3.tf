resource "aws_s3_bucket" "opg_service_perf_bucket" {
  bucket = var.opg_service_perf_bucket_name
  acl    = "private"
}

resource "aws_s3_bucket" "opg_service_release_bucket" {
  bucket = var.opg_service_release_bucket_name
  acl    = "private"
}

resource "aws_s3_bucket" "opg_service_elasticsearch_bucket" {
  bucket = var.opg_service_elasticsearch_bucket_name
  acl    = "private"
}