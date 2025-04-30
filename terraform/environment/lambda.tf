variable "timestream_connector_artifact_name" {
  type    = string
  default = "bootstrap"
}

# Build Lambda Zip
data "archive_file" "lambda_go_connector_zip" {
  type        = "zip"
  source_file = "../../kinesis-go-application/${var.timestream_connector_artifact_name}"
  output_path = "../../kinesis-go-application/${var.timestream_connector_artifact_name}.zip"
}

# Create AWS Lambda
resource "aws_lambda_function" "lambda_go_connector" {
  filename      = data.archive_file.lambda_go_connector_zip.output_path
  function_name = "opg-metrics-kinesis-connector"
  role          = aws_iam_role.lambda_go_connector.arn
  handler       = var.timestream_connector_artifact_name

  source_code_hash = filebase64sha256("../../kinesis-go-application/${var.timestream_connector_artifact_name}.zip")

  runtime = "provided.al2"

  environment {
    variables = {
      DATA_STREAM_NAME = var.name
      DATABASE_NAME    = var.name
      TABLE_NAME       = var.name
    }
  }

  tracing_config {
    mode = "Active"
  }

}

resource "aws_lambda_function_event_invoke_config" "lambda_go_connector" {
  function_name                = aws_lambda_function.lambda_go_connector.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
}

# Create Lambda Event Source Mapping
resource "aws_lambda_event_source_mapping" "lambda_go_connector" {
  batch_size        = 100
  event_source_arn  = aws_kinesis_stream.metrics_input.arn
  function_name     = aws_lambda_function.lambda_go_connector.arn
  starting_position = "LATEST"

  depends_on = [
    aws_iam_role_policy_attachment.kinesis_processing
  ]
}
