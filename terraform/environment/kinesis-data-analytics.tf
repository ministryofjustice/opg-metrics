resource "aws_s3_bucket" "flink" {
  bucket = var.flink_name
}

resource "aws_s3_bucket_object" "flink" {
  bucket = aws_s3_bucket.flink.bucket
  key    = var.flink_name
  source = "../../kinesis-analytics-application/timestreamsink-1.0-SNAPSHOT.jar"
}

resource "aws_cloudwatch_log_group" "flink" {
  name = var.flink_name
}

resource "aws_cloudwatch_log_stream" "flink" {
  name           = var.flink_name
  log_group_name = aws_cloudwatch_log_group.flink.name
}

resource "aws_kinesisanalyticsv2_application" "flink" {
  name                   = var.flink_name
  runtime_environment    = "FLINK-1_8"
  service_execution_role = aws_iam_role.flink_execution.arn

  application_configuration {
    application_code_configuration {
      code_content {
        s3_content_location {
          bucket_arn = aws_s3_bucket.flink.arn
          file_key   = aws_s3_bucket_object.flink.key
        }
      }

      code_content_type = "ZIPFILE"
    }

    environment_properties {
      property_group {
        property_group_id = "FlinkApplicationProperties"

        property_map = {
          InputStreamName           = var.name
          Region                    = data.aws_region.current.name
          TimestreamDbName          = var.name
          TimestreamTableName       = var.name
          TimestreamIngestBatchSize = "10"
        }
      }
    }



    flink_application_configuration {
      checkpoint_configuration {
        configuration_type = "DEFAULT"
      }

      monitoring_configuration {
        configuration_type = "CUSTOM"
        log_level          = "DEBUG"
        metrics_level      = "TASK"
      }

      parallelism_configuration {
        auto_scaling_enabled = false
        configuration_type   = "CUSTOM"
        parallelism          = 1
        parallelism_per_kpu  = 1
      }
    }
  }
  cloudwatch_logging_options {
    log_stream_arn = aws_cloudwatch_log_stream.flink.arn
  }

  tags = local.tags
}
