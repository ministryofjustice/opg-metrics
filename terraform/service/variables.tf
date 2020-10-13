variable "region" {
  default = "eu-west-1"
}

variable "name" {
  default = "opg-metrics"
}

variable "vpc" {
  default = "opg-metrics-vpc"
}

variable "opg_service_elasticsearch_bucket_name" {
  default = "opg-service-elasticsearch-bucket"
}

variable "opg_service_perf_bucket_name" {
  default = "opg-service-perf-bucket"
}

variable "opg_service_release_bucket_name" {
  default = "opg-service-release-bucket"
}

variable "service_perf_stream_name" {
  default = "service_perf_data_stream"
}

variable "service_es_stream_name" {
  default = "service_es_stream_name"
}

variable "service_release_stream_name" {
  default = "service_release_data_stream"
}

variable "data_stream_firehose_name" {
  default = "data-stream-firehose"
}

variable "direct_firehose_name" {
  default = "direct-firehose"
}

variable "kinesis_gateway_role" {
  default = "arn:aws:iam::995199299616:role/KinesisApiGatewayRole"
}
