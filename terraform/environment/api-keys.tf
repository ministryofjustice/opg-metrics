module "trusted_service_access_demo" {
  trusted_service_name           = "demo"
  source                         = "../modules/trusted_service_access"
  aws_api_gateway_rest_api       = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  aws_api_gateway_stage          = aws_api_gateway_stage.kinesis_stream_api_gateway.stage_name
  secret_recovery_window_in_days = 0
  identifiers_arns = [
    "arn:aws:iam::367815980639:root/"
  ]
}

module "trusted_service_access_use_a_lasting_power_of_attorney_development" {
  trusted_service_name           = "use-a-lasting-power-of-attorney-development"
  source                         = "../modules/trusted_service_access"
  aws_api_gateway_rest_api       = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  aws_api_gateway_stage          = aws_api_gateway_stage.kinesis_stream_api_gateway.stage_name
  secret_recovery_window_in_days = 0
  identifiers_arns = [
    "arn:aws:iam::367815980639:root/"
  ]
}
