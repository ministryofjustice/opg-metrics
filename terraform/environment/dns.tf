data "aws_route53_zone" "opg_metrics" {
  provider = aws.management
  name     = "metrics.opg.service.justice.gov.uk"
}

resource "aws_route53_record" "opg_metrics" {
  provider = aws.management
  # <environment.>api.metrics.opg.service.justice.gov.uk
  name    = "${local.dns_namespace_env}api.${data.aws_route53_zone.opg_metrics.name}"
  type    = "A"
  zone_id = data.aws_route53_zone.opg_metrics.id
  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.opg_metrics.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.opg_metrics.regional_zone_id
  }
}

resource "aws_api_gateway_domain_name" "opg_metrics" {
  regional_certificate_arn = aws_acm_certificate_validation.certificate_view.certificate_arn
  domain_name              = "${local.dns_namespace_env}api.${data.aws_route53_zone.opg_metrics.name}"
  security_policy          = "TLS_1_2"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_route53_record" "certificate_validation_view" {
  provider = aws.management
  for_each = {
    for dvo in aws_acm_certificate.certificate_view.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.opg_metrics.zone_id
}
resource "aws_acm_certificate_validation" "certificate_view" {
  certificate_arn         = aws_acm_certificate.certificate_view.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation_view : record.fqdn]
}
resource "aws_acm_certificate" "certificate_view" {
  domain_name       = "${local.dns_namespace_env}api.${data.aws_route53_zone.opg_metrics.name}"
  validation_method = "DNS"
}
