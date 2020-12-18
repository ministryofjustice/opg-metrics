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

  body = <<EOF
  {
  "swagger": "2.0",
  "info": {
    "title": "kinesis-stream"
  },
  "basePath": "/kinesis",
  "schemes": [
    "https"
  ],
  "paths": {
    "/streams": {
      "get": {
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json"
        ],
        "responses": {
          "200": {
            "description": "200 response",
            "schema": {
              "$ref": "#/definitions/Empty"
            }
          }
        },
        "x-amazon-apigateway-integration": {
          "type": "aws",
          "credentials": "${aws_iam_role.kinesis_apigateway.arn}",
          "uri": "arn:aws:apigateway:${data.aws_region.current.name}:kinesis:action/ListStreams",
          "responses": {
            "default": {
              "statusCode": "200"
            }
          },
          "requestTemplates": {
            "application/json": "{}"
          },
          "passthroughBehavior": "when_no_templates",
          "httpMethod": "POST"
        }
      }
    },
    "/streams/${var.name}/records": {
      "put": {
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json"
        ],
        "responses": {
          "200": {
            "description": "200 response",
            "schema": {
              "$ref": "#/definitions/Empty"
            }
          }
        },
        "x-amazon-apigateway-integration": {
          "type": "aws",
          "credentials": "${aws_iam_role.kinesis_apigateway.arn}",
          "uri": "arn:aws:apigateway:${data.aws_region.current.name}:kinesis:action/PutRecords",
          "responses": {
            "default": {
              "statusCode": "200"
            }
          },
          "requestTemplates": {
            "application/json": "{\n    \"StreamName\": \"${var.name}\",\n    \"Records\": [\n       #foreach($elem in $input.path('$.records'))\n          {\n            \"Data\": \"$util.base64Encode($elem.data)\",\n            \"PartitionKey\": \"$elem.partition-key\"\n          }#if($foreach.hasNext),#end\n        #end\n    ]\n}"
          },
          "passthroughBehavior": "when_no_templates",
          "httpMethod": "POST"
        }
      }
    }
  },
  "definitions": {
    "Empty": {
      "type": "object",
      "title": "Empty Schema"
    },
    "PutRecord": {
      "type": "object",
      "properties": {
        "Data": {
          "type": "string"
        },
        "PartitionKey": {
          "type": "string"
        }
      },
      "title": "PutRecord proxy single-record payload"
    }
  }
}
EOF
}
