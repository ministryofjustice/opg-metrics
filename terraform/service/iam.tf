resource "aws_iam_role" "role" {
  name = var.name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "kinesis.amazonaws.com",
          "apigateway.amazonaws.com"
          ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "inline-policy" {
  name   = var.name
  role   = aws_iam_role.role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.bucket.arn}",
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "apigateway:*",
        "kinesis:*"
      ],
      "Resource": "${aws_kinesis_stream.stream.arn}"
    },
    {
      "Effect": "Allow",
            "Action": [
                "apigateway:*",
                "kinesis:*"
            ],
            "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "data-analytics-inline-policy" {
  name   = "${var.name}_data_analytics"
  role   = aws_iam_role.role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ReadCode",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "arn:aws:s3:::ka-app-code-metrics/timestreamsink-1.0-SNAPSHOT.jar"
            ]
        },
        {
            "Sid": "ListCloudwatchLogGroups",
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups"
            ],
            "Resource": [
                "arn:aws:logs:eu-west-1:995199299616:log-group:*"
            ]
        },
        {
            "Sid": "ListCloudwatchLogStreams",
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:eu-west-1:995199299616:log-group:/aws/kinesis-analytics/OPGMetricsApplication:log-stream:*"
            ]
        },
        {
            "Sid": "PutCloudwatchLogs",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:eu-west-1:995199299616:log-group:/aws/kinesis-analytics/OPGMetricsApplication:log-stream:kinesis-analytics-log-stream"
            ]
        }
    ]
}
EOF
}
