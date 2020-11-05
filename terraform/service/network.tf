module "network" {
  source                         = "../modules/network"
  cidr                           = "10.162.0.0/16"
  tags                           = local.tags
  default_security_group_ingress = [{}]
  default_security_group_egress  = [{}]
}

locals {
  mandatory_moj_tags = {
    business-unit    = "OPG"
    application      = "opg_metrics"
    environment-name = "opg_metrics"
    owner            = "OPGOPS opgteam+opgmetrics@digital.justice.gov.uk"
    is-production    = "true"
    runbook          = "https://github.com/ministryofjustice/opg-metrics"
    source-code      = "https://github.com/ministryofjustice/opg-metrics"
  }

  tags = local.mandatory_moj_tags
}
