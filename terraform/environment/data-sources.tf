data "aws_kms_alias" "cloudwatch_application_logs_encryption" {
  name = "alias/${data.aws_default_tags.current.tags.application}-cloudwatch-log-groups-${local.environment.account_name}"
}
