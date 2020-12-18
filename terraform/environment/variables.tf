variable "name" {
  default = "opg-metrics"
  description = "The name of the service"
}

variable "flink_name" {
  default = "opg-metrics-flink"
  description = "Name used for Kinesis Analytics Application and its resources."
}
