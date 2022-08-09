module "trusted_service_access_demo" {
  trusted_service_name               = "demo"
  source                             = "../modules/trusted_service_access"
  aws_api_gateway_rest_api           = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  aws_api_gateway_stage              = aws_api_gateway_stage.kinesis_stream_api_gateway.stage_name
  secret_recovery_window_in_days     = 0
  secretsmanager_api_keys_kms_key_id = aws_kms_key.api_key.key_id
  identifiers_arns = [
    "arn:aws:iam::367815980639:root"
  ]
}

module "trusted_service_access_use_a_lasting_power_of_attorney_development" {
  trusted_service_name               = "use-a-lasting-power-of-attorney-development"
  source                             = "../modules/trusted_service_access"
  aws_api_gateway_rest_api           = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  aws_api_gateway_stage              = aws_api_gateway_stage.kinesis_stream_api_gateway.stage_name
  secret_recovery_window_in_days     = 0
  secretsmanager_api_keys_kms_key_id = aws_kms_key.api_key.key_id
  identifiers_arns = [
    "arn:aws:iam::367815980639:root"
  ]
}

module "trusted_service_access_costs_to_metrics_development" {
  trusted_service_name               = "costs-to-metrics-development"
  source                             = "../modules/trusted_service_access"
  aws_api_gateway_rest_api           = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  aws_api_gateway_stage              = aws_api_gateway_stage.kinesis_stream_api_gateway.stage_name
  secret_recovery_window_in_days     = 0
  secretsmanager_api_keys_kms_key_id = aws_kms_key.api_key.key_id
  identifiers_arns = [
    "arn:aws:iam::311462405659:root"
  ]
}

module "trusted_service_access_sirius_development" {
  trusted_service_name               = "sirius-development"
  source                             = "../modules/trusted_service_access"
  aws_api_gateway_rest_api           = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  aws_api_gateway_stage              = aws_api_gateway_stage.kinesis_stream_api_gateway.stage_name
  secret_recovery_window_in_days     = 0
  secretsmanager_api_keys_kms_key_id = aws_kms_key.api_key.key_id
  identifiers_arns = [
    "arn:aws:iam::288342028542:root"
  ]
}

module "trusted_service_access_sirius_preproduction" {
  trusted_service_name               = "sirius-preproduction"
  source                             = "../modules/trusted_service_access"
  aws_api_gateway_rest_api           = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  aws_api_gateway_stage              = aws_api_gateway_stage.kinesis_stream_api_gateway.stage_name
  secret_recovery_window_in_days     = 0
  secretsmanager_api_keys_kms_key_id = aws_kms_key.api_key.key_id
  identifiers_arns = [
    "arn:aws:iam::492687888235:api-ecs-preproduction-20200204165900331400000008",
    "arn:aws:iam::492687888235:api-ecs-preproduction-2021040714392497160000000a"
  ]
}

module "trusted_service_access_sirius_production" {
  trusted_service_name               = "sirius-production"
  source                             = "../modules/trusted_service_access"
  aws_api_gateway_rest_api           = aws_api_gateway_rest_api.kinesis_stream_api_gateway.id
  aws_api_gateway_stage              = aws_api_gateway_stage.kinesis_stream_api_gateway.stage_name
  secret_recovery_window_in_days     = 0
  secretsmanager_api_keys_kms_key_id = aws_kms_key.api_key.key_id
  identifiers_arns = [
    "arn:aws:iam::649098267436:api-ecs-production-20190802114727697300000001",
    "arn:aws:iam::649098267436:api-ecs-production-2021080908515105620000000a"
  ]
}
