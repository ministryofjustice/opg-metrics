resource "aws_iam_role" "flink_execution" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.flink_execution_assume.json
}

data "aws_iam_policy_document" "flink_execution_assume" {
  statement {
    sid = "1"

    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "kinesis.amazonaws.com",
        "apigateway.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "flink_execution_one" {
  statement {
    sid = "1"

    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.kinesis_data_analytics.arn,
      "${aws_s3_bucket.kinesis_data_analytics.arn}/*"
    ]
  }
  statement {
    sid = "1"

    effect = "Allow"

    actions = [
      "apigateway:*",
      "kinesis:*",
    ]

    resources = [
      aws_kinesis_stream.metrics_input.arn
    ]
  }
  statement {
    sid = "1"

    effect = "Allow"

    actions = [
      "apigateway:*",
      "kinesis:*",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "flink_execution_one" {
  name   = var.name
  role   = aws_iam_role.flink_execution.id
  policy = data.aws_iam_policy_document.flink_execution_one.json
}

data "aws_iam_policy_document" "flink_execution_two" {
  version = "2012-10-17"

  statement {
    sid    = "ReadCode"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    resources = [
      "${aws_s3_bucket.flink.arn}/timestreamsink-1.0-SNAPSHOT.jar",
    ]
  }

  statement {
    sid    = "ListCloudwatchLogGroups"
    effect = "Allow"

    actions = [
      "logs:DescribeLogGroups",
    ]

    resources = [
      "${aws_cloudwatch_log_group.flink.arn}:*",
    ]
  }

  statement {
    sid    = "ListCloudwatchLogStreams"
    effect = "Allow"

    actions = [
      "logs:DescribeLogStreams",
    ]

    resources = [
      "${aws_cloudwatch_log_group.flink.arn}:log-stream:*",
    ]
  }

  statement {
    sid    = "PutCloudwatchLogs"
    effect = "Allow"

    actions = [
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_stream.flink.arn,
    ]
  }
}

resource "aws_iam_role_policy" "flink_execution_two" {
  name   = "${var.name}_data_analytics"
  role   = aws_iam_role.flink_execution.id
  policy = data.aws_iam_policy_document.flink_execution_two.json
}