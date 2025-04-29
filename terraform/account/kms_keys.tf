module "cloudwatch_log_group_kms_key" {
  source              = "../modules/kms_key"
  administrator_roles = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/breakglass"]
  alias               = "${data.aws_default_tags.current.tags.application}-cloudwatch-log-groups-${local.account_name}"
  decryption_roles    = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/operator"]
  description         = "KMS key for opg-metrics cloudwatch log group encryption ${local.account_name}"
  encryption_roles    = []
  usage_services = [
    "logs.eu-west-1.amazonaws.com",
    "logs.eu-west-2.amazonaws.com",
  ]

  providers = {
    aws.eu_west_1 = aws
    aws.eu_west_2 = aws.eu-west-2
  }
}
