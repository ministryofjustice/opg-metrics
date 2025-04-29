module "cloudwatch_log_group_kms_key" {
  source              = "../modules/kms_key"
  administrator_roles = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/breakglass"]
  alias               = "cloudwatch-log-groups-${local.account_name}"
  decryption_roles    = [local.account_name == "production" ? "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/breakglass" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/operator"]
  description         = "KMS Key for Cloudwatch log group encryption ${local.account_name}"
  encryption_roles    = [local.account_name == "production" ? "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/breakglass" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/operator"]
  usage_services = [
    "logs.eu_west_1.amazonaws.com",
    "logs.eu_west_2.amazonaws.com",
  ]

  providers = {
    aws.eu_west_1 = aws
    aws.eu_west_2 = aws.eu-west-2
  }
}
