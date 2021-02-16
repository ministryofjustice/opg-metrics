resource "aws_api_gateway_deployment" "kinesis_stream_api_gateway" {
  rest_api_id = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.kinesis_stream_api_gateway.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  stage_name = ""
}

resource "aws_api_gateway_stage" "kinesis_stream_api_gateway" {
  deployment_id = aws_api_gateway_deployment.kinesis_stream_api_gateway.id
  rest_api_id   = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  stage_name    = terraform.workspace
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
