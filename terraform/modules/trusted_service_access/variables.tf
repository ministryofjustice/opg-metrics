variable "trusted_service_name" {
  type = string
}

variable "identifiers_arns" {
  type = list(string)
}

variable "aws_api_gateway_rest_api" {
  type = string
}

variable "aws_api_gateway_stage" {
  type = string
}

variable "usage_plan_quota_settings_limit" {
  type    = number
  default = 10000
}

variable "usage_plan_quota_settings_offset" {
  type    = number
  default = 2
}

variable "usage_plan_quota_settings_period" {
  type    = string
  default = "WEEK"
}

variable "usage_plan_throttle_settings_burst_limit" {
  type    = number
  default = 5
}

variable "usage_plan_throttle_settings_rate_limit" {
  type    = number
  default = 10
}

variable "secret_recovery_window_in_days" {
  type    = number
  default = 7
}
