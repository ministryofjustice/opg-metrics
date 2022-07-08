resource "aws_kinesis_stream" "metrics_input" {
  name             = var.name
  shard_count      = 1
  retention_period = 24
  encryption_type  = "KMS"
  kms_key_id       = aws_kms_key.kinesis_metrics_input.id
}
