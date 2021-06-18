locals {
  account_name = lookup(var.account_mapping, terraform.workspace, "development")
  environment  = lower(terraform.workspace)

  dns_namespace_acc = local.environment == "production" ? "" : "${local.account_name}."

  mandatory_moj_tags = {
    business-unit    = "OPG"
    application      = "opg-metrics"
    environment-name = terraform.workspace
    owner            = "OPGOPS opgteam+opgmetrics@digital.justice.gov.uk"
    is-production    = "true"
    runbook          = "https://github.com/ministryofjustice/opg-metrics"
    source-code      = "https://github.com/ministryofjustice/opg-metrics"
  }

  tags = local.mandatory_moj_tags
}
