variable "region" {
  default = "eu-west-1"
}

variable "name" {
  default = "opg-metrics"
}

variable "flink_name" {
  default = "opg-metrics-flink"
}

variable "kinesis_gateway_role" {
  default = "arn:aws:iam::995199299616:role/KinesisApiGatewayRole"
}
