resource "aws_kinesis_stream" "metrics_input" {
  name             = var.name
  shard_count      = 1
  retention_period = 24
  encryption_type  = "KMS"
  kms_key_id       = data.aws_kms_alias.kinesis_encryption.id
}
