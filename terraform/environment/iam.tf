resource "aws_iam_role" "lambda_go_connector" {
  name               = "LambdaKinesisRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_go_connector_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_go_connector_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "timestream.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_policy" "lambda_go_connector_kinesis_processing" {
  name        = "allow_kinesis_processing"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = data.aws_iam_policy_document.lambda_go_connector_kinesis_processing_policy.json
}

data "aws_iam_policy_document" "lambda_go_connector_kinesis_processing_policy" {
  statement {

    effect = "Allow"

    #tfsec:ignore:aws-iam-no-policy-wildcards
    actions = [
      "kinesis:ListShards",
      "kinesis:ListStreams",
      "kinesis:*"
    ]

    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = [
      "arn:aws:kinesis:*:*:*"
    ]
  }
  statement {

    effect = "Allow"

    #tfsec:ignore:aws-iam-no-policy-wildcards
    actions = [
      "stream:GetRecord",
      "stream:GetShardIterator",
      "stream:DescribeStream",
      "stream:*"
    ]

    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = [
      "arn:aws:stream:*:*:*"
    ]
  }

  statement {
    sid    = "TimestreamAccess"
    effect = "Allow"

    #tfsec:ignore:aws-iam-no-policy-wildcards
    actions = [
      "timestream:*",
    ]

    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = [
      "*",
    ]
  }
}

# IAM Policy Creation: Allow Cloudwatch Logging

resource "aws_iam_policy" "lambda_go_connector_logging" {
  name        = "allow_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = data.aws_iam_policy_document.lambda_go_connector_logging_policy.json
}

data "aws_iam_policy_document" "lambda_go_connector_logging_policy" {
  statement {

    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "lambda_go_connector_logging" {
  role       = aws_iam_role.lambda_go_connector.name
  policy_arn = aws_iam_policy.lambda_go_connector_logging.arn
}

resource "aws_iam_role_policy_attachment" "kinesis_processing" {
  role       = aws_iam_role.lambda_go_connector.name
  policy_arn = aws_iam_policy.lambda_go_connector_kinesis_processing.arn
}

resource "aws_iam_role" "kinesis_apigateway" {
  name               = "KinesisApiGatewayRole"
  assume_role_policy = data.aws_iam_policy_document.kinesis_apigateway_assume_role_policy.json
}

data "aws_iam_policy_document" "kinesis_apigateway_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
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

    #tfsec:ignore:aws-iam-no-policy-wildcards
    actions = [
      "apigateway:*",
      "kinesis:*",
    ]

    #tfsec:ignore:aws-iam-no-policy-wildcards
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
