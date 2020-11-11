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
