resource "aws_kinesis_stream" "metrics_input" {
  name             = var.name
  shard_count      = 1
  retention_period = 24
}
