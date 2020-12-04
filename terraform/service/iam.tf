resource "aws_iam_role" "kinesis_apigateway" {
  name               = "KinesisApiGatewayRole"
  assume_role_policy = data.aws_iam_policy_document.kinesis_apigateway_assume_role_policy.json
}

data "aws_iam_policy_document" "kinesis_apigateway_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [
        "kinesisanalytics.amazonaws.com",
        "apigateway.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "kinesis_apigateway" {
  statement {

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

resource "aws_iam_role_policy" "kinesis_apigateway" {
  name   = "KinesisApiGatewayPolicy"
  role   = aws_iam_role.kinesis_apigateway.id
  policy = data.aws_iam_policy_document.kinesis_apigateway.json
}

resource "aws_iam_role" "flink_execution" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.flink_execution_assume.json
}

data "aws_iam_policy_document" "flink_execution_assume" {
  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "kinesis.amazonaws.com",
        "kinesisanalytics.amazonaws.com",
        "apigateway.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "flink_execution_one" {
  statement {

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

    effect = "Allow"

    actions = [
      "apigateway:*",
      "kinesis:*",
    ]

    resources = [
      aws_kinesis_stream.metrics_input.arn
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
      "${aws_s3_bucket.flink.arn}/${aws_s3_bucket_object.flink.key}",
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
