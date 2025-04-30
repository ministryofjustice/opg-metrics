data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_default_tags" "current" {}

data "aws_kms_alias" "cloudwatch_application_logs_encryption" {
  name = "alias/${data.aws_default_tags.current.tags.application}-cloudwatch-log-groups-${local.environment.account_name}"
}
