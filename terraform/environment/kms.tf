resource "aws_kms_key" "api_key" {
  description             = "opg metrics api key encryption ${local.environment_name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.api_key_kms.json
}

resource "aws_kms_alias" "api_key_alias" {
  name          = "alias/opg_metrics_api_key_encryption"
  target_key_id = aws_kms_key.api_key.key_id
}

# See the following link for further information
# https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
data "aws_iam_policy_document" "api_key_kms" {
  statement {
    sid       = "Enable Root account permissions on Key"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }

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
        "arn:aws:iam::311462405659:root",
        "arn:aws:iam::288342028542:root",
        "arn:aws:iam::492687888235:role/api-ecs-preproduction",
        "arn:aws:iam::649098267436:role/api-ecs-production",
        "arn:aws:iam::679638075911:role/jenkins-primary-20190425141320485900000006",
        "arn:aws:iam::997462338508:role/jenkins-primary-20190430083911121200000007"
      ]
    }
  }

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
