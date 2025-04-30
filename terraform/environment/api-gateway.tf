resource "aws_api_gateway_deployment" "kinesis_stream_api_gateway" {
  rest_api_id = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.kinesis_stream_api_gateway.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "kinesis_stream_api_gateway" {
  depends_on           = [aws_cloudwatch_log_group.kinesis_stream_api_gateway]
  deployment_id        = aws_api_gateway_deployment.kinesis_stream_api_gateway.id
  rest_api_id          = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  cache_cluster_size   = "0.5"
  stage_name           = local.environment_name
  xray_tracing_enabled = true
}

resource "aws_api_gateway_base_path_mapping" "kinesis_stream_api_gateway" {
  api_id      = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  stage_name  = aws_api_gateway_stage.kinesis_stream_api_gateway.stage_name
  domain_name = aws_api_gateway_domain_name.opg_metrics.domain_name
}

resource "aws_api_gateway_rest_api" "kinesis_stream_api_gateway" {
  name = "kinesis-stream"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  body = templatefile("./api/openapi_spec.yaml", local.openapi_template_vars)
}

locals {
  openapi_template_vars = {
    region        = data.aws_region.current.name
    name          = var.name
    allowed_roles = aws_iam_role.kinesis_apigateway.arn
  }
}

resource "aws_cloudwatch_log_group" "kinesis_stream_api_gateway" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.kinesis_stream_api_gateway.id}/${local.environment_name}"
  retention_in_days = 7
}

resource "aws_api_gateway_account" "kinesis_stream_api_gateway" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch_kinesis_stream_api_gateway.arn
}

resource "aws_iam_role" "cloudwatch_kinesis_stream_api_gateway" {
  name = "api_gateway_cloudwatch_kinesis_stream_api_gateway"

  assume_role_policy = data.aws_iam_policy_document.cloudwatch_kinesis_stream_api_gateway_assume_role.json
}


data "aws_iam_policy_document" "cloudwatch_kinesis_stream_api_gateway_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["apigateway.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy" "cloudwatchcloudwatch_kinesis_stream_api_gateway_permissions" {
  name = "default"
  role = aws_iam_role.cloudwatch_kinesis_stream_api_gateway.id

  policy = data.aws_iam_policy_document.cloudwatch_kinesis_stream_api_gateway_permissions.json
}

data "aws_iam_policy_document" "cloudwatch_kinesis_stream_api_gateway_permissions" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = [
      "*",
    ]
  }
}
