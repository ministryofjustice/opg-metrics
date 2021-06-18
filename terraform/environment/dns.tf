data "aws_route53_zone" "opg_metrics" {
  provider = aws.management
  name     = "metrics.opg.service.justice.gov.uk"
}

resource "aws_route53_record" "api_gateway" {
  name    = "${local.dns_namespace_env}api.${data.aws_route53_zone.opg_metrics.name}"
  type    = "A"
  zone_id = data.aws_route53_zone.opg_metrics.id
  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.opg_api_gateway.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.opg_api_gateway.regional_zone_id
  }
}
