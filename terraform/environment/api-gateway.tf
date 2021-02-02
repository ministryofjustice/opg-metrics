resource "aws_api_gateway_stage" "kinesis_stream_api_gateway" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  deployment_id = aws_api_gateway_deployment.kinesis_stream_api_gateway.id
}

resource "aws_api_gateway_deployment" "kinesis_stream_api_gateway" {
  depends_on  = [aws_api_gateway_integration.kinesis_stream_api_gateway]
  rest_api_id = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  stage_name  = "dev"
}

resource "aws_api_gateway_resource" "kinesis_stream_api_gateway" {
  rest_api_id = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.kinesis_stream_api_gateway.root_resource_id
  path_part   = "mytestresource"
}

resource "aws_api_gateway_method" "kinesis_stream_api_gateway" {
  rest_api_id   = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  resource_id   = aws_api_gateway_resource.kinesis_stream_api_gateway.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "kinesis_stream_api_gateway" {
  rest_api_id = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  resource_id = aws_api_gateway_resource.kinesis_stream_api_gateway.id
  http_method = aws_api_gateway_method.kinesis_stream_api_gateway.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_rest_api" "kinesis_stream_api_gateway" {
  name = "kinesis-stream"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  body = data.template_file._.rendered
}

locals {
  openapispec = file("./api/openapi_spec.json")
  openapi_template_vars = {
    region        = data.aws_region.current.name
    name          = var.name
    allowed_roles = aws_iam_role.kinesis_apigateway.arn
  }
}
data "template_file" "_" {
  template = local.openapispec
  vars     = local.openapi_template_vars
}
