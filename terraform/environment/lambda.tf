variable "timestream_connector_artifact_name" {
  type = string
}

# Build Lambda Zip

resource "null_resource" "lambda_go_connector_zip" {
  provisioner "local-exec" {
    command = "zip ${var.timestream_connector_artifact_name}.zip ../../kinesis-go-application/${var.timestream_connector_artifact_name}"
  }
}

# Create AWS Lambda

resource "aws_lambda_function" "lambda_go_connector" {
  filename      = "${var.timestream_connector_artifact_name}.zip"
  function_name = "terraform-kinesis-lambda"
  role          = aws_iam_role.lambda_go_connector.arn
  handler       = "main.handle"

  source_code_hash = filebase64sha256("${var.timestream_connector_artifact_name}.zip")

  runtime = "go1.x"

  environment {
    variables = {
      DATA_STREAM_NAME = var.name
      DATABASE_NAME    = var.name
      TABLE_NAME       = var.name
    }
  }
}

resource "aws_lambda_function_event_invoke_config" "lambda_go_connector" {
  function_name                = aws_lambda_function.lambda_go_connector.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
}

# Create Lambda Event Source Mapping

resource "aws_lambda_event_source_mapping" "lambda_go_connector" {
  #batch_size        = 5
  event_source_arn  = aws_kinesis_stream.metrics_input.arn
  function_name     = aws_lambda_function.lambda_go_connector.arn
  starting_position = "LATEST"

  depends_on = [
    aws_iam_role_policy_attachment.kinesis_processing
  ]
}
