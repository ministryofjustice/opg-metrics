locals {
  trusted_services = [
    "demo",
  ]
}

# Using sets like this means that there can only be one type of usage plan for all services
# After this is proven, it will be refactored into a module
resource "aws_api_gateway_usage_plan" "trusted_services" {
  for_each     = toset(local.trusted_services)
  name         = each.value
  description  = "trusted service usage plan for ${each.value}"
  product_code = upper(each.value)

  api_stages {
    api_id = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
    stage  = aws_api_gateway_stage.kinesis_stream_api_gateway.stage_name
  }

  quota_settings {
    limit  = 20
    offset = 2
    period = "WEEK"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }
}

resource "aws_api_gateway_api_key" "trusted_services" {
  for_each    = toset(local.trusted_services)
  name        = each.value
  description = "trusted service api key for ${each.value}"
}

resource "aws_api_gateway_usage_plan_key" "trusted_services" {
  for_each      = toset(local.trusted_services)
  key_id        = aws_api_gateway_api_key.trusted_services[each.value].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.trusted_services[each.value].id
}
