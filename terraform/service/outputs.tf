output "firehose_arn" {
  value = aws_iam_role.firehose_role.arn
}

output "opg_service_perf_stream_arn" {
  value = aws_kinesis_stream.opg_service_perf_stream.arn
}

output "aws_api_gateway_rest_api_arn" {
  value = aws_api_gateway_rest_api.kinesis_stream_api_gateway.arn
}

output "aws_api_gateway_rest_api_id" {
  value = aws_api_gateway_stage.kinesis_stream_api_gateway.invoke_url
}
