resource "aws_kms_key" "api_key" {
  description             = "opg metrics api key encryption ${local.environment}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.api_kms_key.json
}

resource "aws_kms_alias" "api_key_alias" {
  name          = "alias/opg_metrics_api_key_encryption"
  target_key_id = aws_kms_key.api_key.key_id
}

# See the following link for further information
# https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
data "aws_iam_policy_document" "api_kms_key" {
  source_policy_documents = [
    data.aws_iam_policy_document.api_kms_cross_account_decryption.json,
    data.aws_iam_policy_document.kms_key_administrator.json
  ]
}

data "aws_iam_policy_document" "s3_kinesis_data_analytics_kms_key" {
  source_policy_documents = [
    data.aws_iam_policy_document.kms_key_administrator.json
  ]
}

data "aws_iam_policy_document" "s3_flink_kms_key" {
  source_policy_documents = [
    data.aws_iam_policy_document.kms_key_administrator.json
  ]
}

data "aws_iam_policy_document" "kinesis_metrics_input_kms_key" {
  source_policy_documents = [
    data.aws_iam_policy_document.kms_key_administrator.json
  ]
}

data "aws_iam_policy_document" "api_kms_cross_account_decryption" {
  statement {
    sid    = "cross account decryption permissions"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::367815980639:root",
        "arn:aws:iam::311462405659:root"
      ]
    }
  }
}

data "aws_iam_policy_document" "kms_key_administrator" {
  statement {
    sid       = "Key Administrator"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/breakglass"]
    }
  }
}

resource "aws_kms_key" "s3_kinesis_data_analytics" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.s3_kinesis_data_analytics_kms_key.json
}

resource "aws_kms_key" "s3_flink" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.s3_flink_kms_key.json
}

resource "aws_kms_key" "kinesis_metrics_input" {
  description             = "This key is used to encrypt kinesis streams"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kinesis_metrics_input_kms_key.json
}
