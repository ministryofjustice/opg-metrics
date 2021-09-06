# Using sets like this means that there can only be one type of usage plan for all services
# After this is proven, it will be refactored into a module
resource "aws_api_gateway_usage_plan" "trusted_services" {
  name         = var.trusted_service_name
  description  = "trusted service usage plan for ${var.trusted_service_name}"
  product_code = upper(var.trusted_service_name)

  api_stages {
    api_id = var.aws_api_gateway_rest_api
    stage  = var.aws_api_gateway_stage
  }

  quota_settings {
    limit  = var.usage_plan_quota_settings_limit
    offset = var.usage_plan_quota_settings_offset
    period = var.usage_plan_quota_settings_period
  }

  throttle_settings {
    burst_limit = var.usage_plan_throttle_settings_burst_limit
    rate_limit  = var.usage_plan_throttle_settings_rate_limit
  }
}

resource "aws_api_gateway_api_key" "trusted_services" {
  name        = var.trusted_service_name
  description = "trusted service api key for ${var.trusted_service_name}"
}

resource "aws_api_gateway_usage_plan_key" "trusted_services" {
  key_id        = aws_api_gateway_api_key.trusted_services.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.trusted_services.id
}

resource "aws_secretsmanager_secret" "api_key" {
  name                    = var.trusted_service_name
  recovery_window_in_days = var.secret_recovery_window_in_days
}

resource "aws_secretsmanager_secret_version" "api_key" {
  secret_id     = aws_secretsmanager_secret.api_key.id
  secret_string = aws_api_gateway_api_key.trusted_services.value
}

resource "aws_secretsmanager_secret_policy" "api_key" {
  secret_arn = aws_secretsmanager_secret.api_key.arn

  policy = data.aws_iam_policy_document.api_key_access.json
}

data "aws_iam_policy_document" "api_key_access" {
  statement {

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.identifiers_arns
    }

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      aws_secretsmanager_secret.api_key.arn
    ]
  }
}
