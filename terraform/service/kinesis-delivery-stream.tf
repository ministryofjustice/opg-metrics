resource "aws_kinesis_firehose_delivery_stream" "opg_service_perf_data_stream" {
  name        = var.data_stream_firehose_name
  destination = "s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.opg_service_perf_stream.arn
    role_arn           = aws_iam_role.firehose_role.arn
  }

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.opg_service_perf_bucket.arn
  }
}

resource "aws_kinesis_firehose_delivery_stream" "opg_service_perf_direct_stream" {
  name        = var.direct_firehose_name
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.opg_service_perf_bucket.arn
  }
}

resource "aws_kinesis_firehose_delivery_stream" "opg_service_release_data_stream" {
  name        = "opg_service_release_data_stream_firehose"
  destination = "s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.opg_service_release_stream.arn
    role_arn           = aws_iam_role.firehose_role.arn
  }

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.opg_service_release_bucket.arn
  }
}

resource "aws_kinesis_firehose_delivery_stream" "opg_service_release_direct_stream" {
  name        = "opg_service_release_direct_stream_firehose"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.opg_service_release_bucket.arn
  }
}

resource "aws_kinesis_firehose_delivery_stream" "test" {
  depends_on = [aws_iam_role_policy.firehose-elasticsearch]

  name        = "terraform-kinesis-firehose-es"
  destination = "elasticsearch"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.opg_service_es_stream.arn
    role_arn           = aws_iam_role.firehose_role.arn
  }

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.opg_service_elasticsearch_bucket.arn
  }
  elasticsearch_configuration {
    domain_arn = aws_elasticsearch_domain.test_cluster.arn
    role_arn   = aws_iam_role.firehose_role.arn
    index_name = "test"

    vpc_config {
      subnet_ids         = data.aws_subnet_ids.data.ids
      security_group_ids = [aws_security_group.kinesis.id]
      role_arn           = aws_iam_role.firehose_role.arn
    }
  }
}

resource "aws_iam_role_policy" "firehose-elasticsearch" {
  name   = "elasticsearch"
  role   = aws_iam_role.firehose_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "es:*"
      ],
      "Resource": [
        "${aws_elasticsearch_domain.test_cluster.arn}",
        "${aws_elasticsearch_domain.test_cluster.arn}/*"
      ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "ec2:DescribeVpcs",
            "ec2:DescribeVpcAttribute",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeNetworkInterfaces",
            "ec2:CreateNetworkInterface",
            "ec2:CreateNetworkInterfacePermission",
            "ec2:DeleteNetworkInterface"
          ],
          "Resource": [
            "*"
          ]
        }
  ]
}
EOF
}
