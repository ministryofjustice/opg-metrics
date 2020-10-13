resource "aws_kinesis_stream" "opg_service_perf_stream" {
  name             = var.service_perf_stream_name
  shard_count      = 1
  retention_period = 24
}

resource "aws_kinesis_stream" "opg_service_release_stream" {
  name             = var.service_release_stream_name
  shard_count      = 1
  retention_period = 24
}

resource "aws_kinesis_stream" "opg_service_es_stream" {
  name             = var.service_es_stream_name
  shard_count      = 1
  retention_period = 24
}

resource "aws_security_group" "kinesis" {
  name        = "${var.vpc}-kinesis"
  description = "Managed by Terraform"
  vpc_id      = data.aws_vpc.vpc.id
}

resource "aws_security_group_rule" "kinesis" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.elasticsearch.id
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}
