variable "region" {
  default = "eu-west-1"
}

variable "name" {
  default = "opg-metrics"
}

variable "bucket_name" {
  default = "tf-opg-bucket"
}

variable "stream_name" {
  default = "data-stream"
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
