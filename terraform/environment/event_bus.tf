resource "aws_cloudwatch_event_bus" "main" {
  name = local.default_tags.environment-name
}
